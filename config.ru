# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'svn_handler'

use SvnHandler

run Codefoundry::Application
