class MoonshineMinistryHacksGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # manifests
      m.directory "app/manifests"
      m.file "app/manifests/application_manifest.rb"
      m.directory "app/manifests/tempaltes"
      m.file "app/manifests/passenger.vhost.erb"
      m.file "app/manifests/README"

      # config
      m.directory "config/deploy/ca"
      m.template "config/deploy/ca/dev_moonshine.yml"
      m.template "config/deploy/ca/prod_moonshine.yml"
      m.template "config/deploy/ca/staging_moonshine.yml"
      m.template "config/deploy.rb"
  end
end
