require 'net/http'

class Net::HTTP #:nodoc:
  # Streaming version of Net::HTTP#request.
  #
  # Behaves identically to Net::HTTP#request, except that the body is not
  # automatically read in initialize.  The body is left unread until
  # stream_body is called (which can be called safely in the given block).
  # stream_body takes an optional block and yields chunks of the HTTP response
  # body as they are read from the connection.  This allows the caller to
  # initiate the request, and read the body later without needing to read and
  # buffer the entire response body in memory.
  #
  # When using this request method, keep in mind:
  # * The request body should not be accessed until stream_body is called
  def request_streaming( req, body = nil, &block ) #:yield: +response+
    unless started?
      start {
        # default the connection header to close (instead of keep-alive)
        req['connection'] ||= 'close'
        return request_streaming( req, body, &block )
      }
    end
    if proxy_user()
      # if there is a proxy user, set up basic auth to use it.  if use_ssl is
      # set, skip this because SSL cannot be proxied without security problems
      req.proxy_basic_auth proxy_user(), proxy_pass() unless use_ssl?
    end
    req.set_body_internal body
    res = transport_request_streaming( req, &block )
    res
    # Note: no sspi support here!
  end

  # Yields chunks of the waiting HTTPReponse to a block, if given.  After this
  # method is run, the body can be accessed through the response's body method.
  def stream_body( &block )
    res = @res

    @res.reading_body(@socket, @req.response_body_permitted?) {
      @res.read_body( &block )
    }
    end_transport( @req, @res )
    # forget about the request/response
    @req = @res = nil

    res.body
  end

  private

  # clean up after the last streaming request, if necessary
  def cleanup_stream
    stream_body if @req and @res
  end

  # wrap transport_request so we can clean up the stream (if necessary) first
  alias transport_request_nostream transport_request
  def transport_request( req )
    cleanup_stream
    transport_request_nostream
  end

  # the streaming version of transport_request
  def transport_request_streaming( req )
    cleanup_stream

    begin_transport req
    req.exec @socket, @curr_http_version, edit_path(req.path)
    begin
      res = Net::HTTPResponse.read_new( @socket )
    end while res.kind_of?( Net::HTTPContinue )

    # save the response/request
    @req = req
    @res = res

    # to stream the response, we don't insist that the body is read here.
    # instead, we provide the stream_body method, which needs to be called.
    #
    # if it is *not* called before the next request, transport_request and
    # transport_request_streaming will call it via cleanup_stream.

    yield res if block_given?

    res
  rescue => exception
    D "Close because of error #{exception}"
    @socket.close unless @socket.closed?
    raise exception
  end
end
