class GitHandler
  MATCH_RE = Regexp.new('^/projects/(\\w+)/repositories/(\\w+)\.git(/.*)')

  def initialize( app )
    @logger = ActiveRecord::Base.logger

    @app = app

    @config = {
        :project_root => Settings.repository_base_path,
        :git_path => Settings.git_app_config.git_path,
        :upload_pack => true,
        :receive_pack => true
      }

    @git_provider = GitHttp::App.new
    @git_provider.set_config( @config )
  end

  def call( env )
    # if the request is for a git repository (name.git), then send the request to
    # the git handler
    if m = MATCH_RE.match( env['PATH_INFO'] )
      # remove the prefix
      env['PATH_INFO'] = "/git/#{m[1]}/#{m[2]}.git#{m[3]}"
      @git_provider.call( env )
    else
      @app.call( env )
    end
  end
end
