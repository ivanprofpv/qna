# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "qna"
set :repo_url, "git@github.com:ivanprofpv/qna.git"
set :pty, false

# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, "deploy_capistrano"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

set :default_env, {
    path: '/home/deployer/rbenv/plugins/ruby-build/bin:/home/deployer/rbenv/shims:/home/deployer/rbenv/bin:$PATH',
    rbenv_root: '/home/deployer/rbenv'
}

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

set :keep_releases, 4
