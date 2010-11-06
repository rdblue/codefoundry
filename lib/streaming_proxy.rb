require 'rack'
require 'net/http'
require 'streaming_http'

# A streaming proxy class, based on aniero's rack-streaming-proxy
#
# * Some parts copyright (c) 2009 Nathan Witmer (aniero), used via MIT license
# * This version is heavily modified, but aniero's was used for the basis
#
# Debugging output (when options[:debug] is on) is sent to $stderr.  This
# should be okay, since $stderr is usually redirected to logs when running
# detatched from a terminal.
class StreamingProxy

  # Notable changes from aniero's version include:
  # * Added HTTP connection caching and reuse
  # * Replaced dependency on servolux with streaming HTTP patches
  # * No longer needs to spawn a thread to stream requests
  # * Added options
  # * Updated request_method handling
  # * Updated header forwarding
  class Request
    include Rack::Utils

    CRLF = "\r\n"
    DEFAULT_HEADERS = [
        'Accept',
        'Accept-Encoding',
        'Accept-Charset',
        'X-Requested-With',
        'Referer',
        'User-Agent',
        'Cookie',
        'Authorization',
        'Connection',
        'Keep-Alive'
        #DAV TE Depth Label
      ]

    # connection cache
    @@connections = {}

    attr_reader :status, :headers

    def initialize( request, uri, options = {} )
      uri = URI.parse(uri)

      # get the ruby class name of the request object, using the HTTP method
      method = request.request_method.downcase.split('-').map(&:capitalize).join

      $stderr.puts "Forwarding #{method.upcase} to #{uri}" if options[:debug]

      # get an instance of the request class
      proxy_request = Net::HTTP.const_get(method).new("#{uri.path}#{"?" if uri.query}#{uri.query}")

      if request.body and request.content_type
        request.body.rewind # make sure it can be read!
        proxy_request.body_stream = request.body
        proxy_request.content_length = request.content_length || 0
        proxy_request.content_type = request.content_type
      end

      if options[:all_headers]
        request.env.keys.grep(/^HTTP_/).each do |key|
          header = key.split('_')[1..-1].map(&:downcase).map(&:capitalize).join('-')
          proxy_request[header] = request.env[key]
        end
      else
        DEFAULT_HEADERS.each do |header|
          key = "HTTP_#{header.upcase.gsub('-', '_')}"
          proxy_request[header] = request.env[key] if request.env[key]
        end
      end
      proxy_request["X-Forwarded-For"] =
        (request.env["X-Forwarded-For"].to_s.split(/, +/) + [request.env["REMOTE_ADDR"]]).join(", ")

      key = [ uri.host, uri.port ]
      @@connections[ key ] ||= Net::HTTP.start( *key ).tap { |c|
        $stderr.puts "opening new connection" if options[:debug]
      }
      @connection = @@connections[ key ]

      begin
        # if the socket is still open, this will succeed
        @response = @connection.request_streaming( proxy_request )
      rescue EOFError, Errno::EPIPE
        # if the socket is not open, then it is re-opened from the last call to
        # reques.  rewind the body since it was read by the failed request.
        proxy_request.body_stream.rewind if proxy_request.body_stream.respond_to? :rewind
        @response = @connection.request_streaming( proxy_request )
        $stderr.puts "could not reuse connection" if options[:debug]
      end

      @status = @response.code
      @headers = {}
      @response.each_header { |k, v| @headers[k] = v }
    end

    def each( &b )
      # use stream_body to transfer each chunk.  if the content was chunked,
      # re-chunk it.  otherwise, just pass the caller's block to stream_body.
      if @response['Transfer-Encoding'] == 'chunked'
        @connection.stream_body do |chunk|
          size = bytesize( chunk )
          # re-encode and yield the length-prefixed chunk
          b.call( [size.to_s(16), CRLF, chunk, CRLF].join )
        end
        # send an empty chunk to indicate we're finished
        b.call( ["0", CRLF, CRLF].join )
      else
        @connection.stream_body( &b )
      end
    end

  end

  # Creates a new app or middleware.  The given block is called with an
  # instance of Rack::Request and is expected to return a string URI where the
  # request should be proxied to.
  #
  # When used as middle-ware, the given app is called when the block returns a
  # nil URI.  When used as an app (no app is passed to StreamingProxy#new),
  # then the application will generate a 404 message if the mapped URI is nil.
  def initialize( *args, &block )
    # if an app is given, use it.  otherwise, set up a generic 404 app.
    @app = args.shift

    if @app.is_a? Hash
      @options = @app
      @app = nil
    end

    @app ||= lambda { |r| [404, {}, []] }
    @options ||= args.shift
    @options ||= {}

    # save off the block as a URI mapper
    @map = block
  end

  def call( env )
    req = Rack::Request.new( env )
    uri = @map.call( req )

    return @app.call( env ) if @app and not uri

    proxy = StreamingProxy::Request.new( req, uri, @options )

    [proxy.status, proxy.headers, proxy]
  end

end
