# For URL rewriting
require 'uri'

# Add Delta-V extensions to HTTP for SVN
require File.expand_path( '../delta_v', __FILE__ )

# The StreamingProxy class that is used to perform proxy-server interaction
require File.expand_path( '../streaming_proxy', __FILE__ )

class SvnHandler
  MATCH_RE = Regexp.new('^/\\w+\.\\w+.svn/!svn.*')
  REWRITE_RE = Regexp.new('^/(?:(?:p(?:rojects)?)|(?:u(?:sers)?))/(\\w+)/(?:repositories/)?(\\w+)\.svn(/?.*)')

  def initialize( app )
    @logger = ActiveRecord::Base.logger

    @config = {
        :host => Settings.svn_app_config.host,
        :port => Settings.svn_app_config.port || 80,
        :all_headers => true # Must be on to forward SVN headers correctly
      }

    @url_start = "http://#{@config[:host]}:#{@config[:port]}"

    @svn_provider = StreamingProxy.new( app, @config ) do |req|
      if m = MATCH_RE.match( req.path )
        # just add the correct host/port
        @url_start + req.path
      elsif m = REWRITE_RE.match( req.path )
        # construct the correct URL
        "#{@url_start}/#{m[1]}.#{m[2]}.svn#{m[3]}"
      else
        nil
      end
    end
  end

  def call( env )
    # CHECKOUT (and possibly other) requests sent by SVN don't set the
    # Content-Type header, so make sure if the body exists, the content type
    # set to 'text/xml'.  Otherwise, the body isn't forwarded by the proxy.
    env['CONTENT_TYPE'] ||= 'text/xml' if env['rack.input'].size > 0

    # the provider already has the logic to forward any requests that don't
    # match MATCH_RE to the rails app.
    @svn_provider.call( env )
  end
end
