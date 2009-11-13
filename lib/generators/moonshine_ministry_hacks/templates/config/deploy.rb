load "#{File.dirname(__FILE__)}/../lib/capistrano_helper.rb"
server "192.168.1.112", :app, :web, :db, :primary => true

# multistage
set :stages, %w(staging prod dev)
require 'capistrano/ext/multistage'

before "deploy:setup", :upload_certs
after "deploy:setup", :destroy_config_files
