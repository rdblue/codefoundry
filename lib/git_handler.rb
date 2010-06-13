require 'grack/lib/git_http'

class GitHandler
  def initialize( *args )
    @git_provider = GitHttp::App.new
    @git_provider.set_config(
        :project_root => '/home/blue/tmp',
        :git_path => '/usr/bin/git',
        :upload_pack => true,
        :receive_pack => true
      )
  end

  def call( env )
    @git_provider.call( env )
  end
end
