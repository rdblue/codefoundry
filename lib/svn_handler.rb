require 'uri'
require 'rack/streaming_proxy'

class SvnHandler
  def initialize( *args )
    # fake a rack app for StreamingProxy; we use it as an app, not middleware
    fake_app = lambda { |r| [404, {}, []] }
    @svn_provider = Rack::StreamingProxy.new( fake_app ) do |req|
      "http://localhost:3000/" + req.path.sub(/\/svn\//, '')
    end
  end

  def call( env )
    @svn_provider.call( env )
  end
end
