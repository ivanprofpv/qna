# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "qna"
set :repo_url, "git@github.com:ivanprofpv/qna.git"
set :pty, false

# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, "unicorn_deploy"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/qna"
set :deploy_user, 'deploy'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

after 'deploy:publishing', 'unicorn:restart'

set :keep_releases, 4
