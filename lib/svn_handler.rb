# For URL rewriting
require 'uri'

# Add Delta-V extensions to HTTP for SVN
require 'delta_v'

# The StreamingProxy class that is used to perform proxy-server interaction
require 'streaming_proxy'

class SvnHandler
  def initialize( app )
    options = {
        :host => 'dev',
        :port => 80,
        :all_headers => true
      }
    @svn_provider = StreamingProxy.new( app, options ) do |req|
      # right now, we assume SVN is mounted at /svn/
      path_arr = req.path.split('/')
      if path_arr[1] == 'svn'
        "http://#{options[:host]}:#{options[:port]}#{req.path}"
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
    @svn_provider.call( env )
  end
end
