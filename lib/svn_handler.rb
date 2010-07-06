# For URL rewriting
require 'uri'

# Add Delta-V extensions to HTTP for SVN
require 'delta_v'

# The StreamingProxy class that is used to perform proxy-server interaction
require 'streaming_proxy'

class SvnHandler
  def initialize( app )
    settings = Codefoundry::Application.settings
    @prefix = settings.svn_prefix
    @config = {
        :path_prefix => settings.svn_app_config['path_prefix'],
        :host => settings.svn_app_config['host'],
        :port => settings.svn_app_config['port'] || 80,
        :all_headers => true # Must be on to forward SVN headers correctly
      }

    url_start = "http://#{@config[:host]}:#{@config[:port]}"

    # strip off the beginning/ending '/'
    if @config[:path_prefix]
      unless @config[:path_prefix].starts_with? '/'
        @config[:path_prefix] = "/#{@config[:path_prefix]}"
      end
      @config[:path_prefix].chomp!('/')
    end

    @svn_provider = StreamingProxy.new( app, @config ) do |req|
      # right now, we assume SVN is mounted at /svn/
      if req.path.starts_with? @prefix
        # construct the correct URL
        "#{url_start}#{@config[:path_prefix]}/#{req.path.sub(/^#{@prefix}\/?/, '')}"
      else
        nil
      end
    end
  end

  def call( env )
    # CHECKOUT (and possibly other) requests sent by SVN don't set the
    # Content-Type header, so make sure if the body exists, the content type
    # set to 'text/xml'.  Otherwise, the body isn't forwarded by the proxy.
    env['CONTENT_TYPE'] ||= 'text/xml' if env['rack.input'].length > 0

    # the provider already has the logic to forward any requests that don't
    # start with the svn_prefix to the rails app.
    @svn_provider.call( env )
  end
end
