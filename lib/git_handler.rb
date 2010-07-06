require 'rack'
require 'grack/lib/git_http'

class GitHandler
  attr_accessor :app_config

  def initialize( app )
    @app = app
    @app_config = app.app_config

    @prefix = @app_config.git_prefix
    @config = {
        :project_root => @app_config.git_app_config['project_root'],
        :git_path => @app_config.git_app_config['git_path'],
        :upload_pack => true,
        :receive_pack => true
      }

    @git_provider = GitHttp::App.new
    @git_provider.set_config( @config )
  end

  def call( env )
    # if the request starts with git_prefix, handle it
    # otherwise, send it to the rails app
    if env['PATH_INFO'].starts_with? @prefix
      # remove the prefix
      env['PATH_INFO'].sub!(/^#{@prefix}/, '')
      @git_provider.call( env )
    else
      @app.call( env )
    end
  end
end
