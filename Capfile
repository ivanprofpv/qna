# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/sidekiq'
require "thinking_sphinx/capistrano"
require "whenever/capistrano"
require 'capistrano/rails/console'
require 'capistrano3/unicorn'
install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
