# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"
require "capistrano/rails"
require "capistrano/rbenv"
require "capistrano/bundler"
require "capistrano/passenger"
require "thinking_sphinx/capistrano"
require "whenever/capistrano"
require "capistrano/sidekiq"
install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd

set :rbenv_type, :user
set :rbenv_ruby, '2.7.5'

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
