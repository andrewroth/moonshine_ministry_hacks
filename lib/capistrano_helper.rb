task :upload_certs do
  destroy_config_files
  upload "app/manifests/private/certs/", 
    "/tmp/moonshine_config_files/", 
    :recursive => true
end

task :download_private do
  user_before = fetch(:user)
  set :user, "andrewr"
  download "/home/campus/homes/andrewr/private_repo", "app/manifests/private", 
    :hosts => "james.powertochange.org",
    :recursive => true
  set :user, user_before
end

task :destroy_private do
  FileUtils.rm_rf "app/manifests/private"
end

task 'deploy:rollback' do
  # don't rollback
end

task 'destroy_config_files' do
  run "rm -rf /tmp/moonshine_config_files"
end
