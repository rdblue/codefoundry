# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

require 'git_handler'
require 'svn_handler'

use GitHandler
use SvnHandler

run Codefoundry::Application
