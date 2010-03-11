# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'


gem "rails", "3.0.0.beta"

## Bundle edge rails:
# gem "rails", :git => "git://github.com/rails/rails.git"

# ActiveRecord requires a database adapter. By default,
# Rails has selected sqlite3.
gem "sqlite3-ruby", :require => "sqlite3"

## Bundle the gems you use:
# gem "bj"
# gem "hpricot", "0.6"
# gem "sqlite3-ruby", :require => "sqlite3"
# gem "aws-s3", :require => "aws/s3"

## Bundle gems used only in certain environments:
# gem "rspec", :group => :test
# group :test do
#   gem "webrat"
# end

# TODO: fix this, it's from the rails 2.3.5 environment.rb

  # repository access gems
  config.gem 'grit' # git
  # config.gem 'amp' # mercurial

  # search and indexing gems
  # config.gem 'ferret'
  # config.gem 'acts_as_ferret'

  # text formatting
  config.gem 'marker'

  # syntax highlighting
  # uses harsh plug-in, which depends on the ultraviolet gem, which depends on
  # Oniguruma (install from source), see NOTES
  config.gem 'oniguruma' # cause rake gems:install to fail unless onig .so is installed
  config.gem 'ultraviolet', :lib => 'uv'

# be sure to install libsvn-ruby to get the ruby SVN bindings on ubuntu
require 'svn/core'
require 'grit'
require 'marker'
