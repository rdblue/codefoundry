class SvnHandler
  def call( env )
    [200, {'Content-Type' => 'text/plain'}, ["Hello from SVN!"]]
  end
end
