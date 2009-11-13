class MoonshineMinistryHacksGenerator < Rails::Generator::NamedBase
  def initialize(runtime_args, runtime_options = {})
    @git_url = runtime_args.delete_at 1
    super
  end

  def attributes
    @attributes ||= Hash[*@args.collect { |attribute|
      attribute.split(':')
    }.flatten]
  end

  def domain() attributes["#{@host}.domain"] || DEFAULT_DOMAINS[@host] end

  def git_url() @git_url end

  # TODO: use a yaml file and record more info, like the private repo info
  DEFAULT_DOMAINS = {
    'ca' => 'powertochange.org',
    'mh' => 'ministryhacks.com',
  }

  def manifest
    record do |m|
      # manifests
      m.directory "app/manifests"
      m.file "manifests/application_manifest.rb", "app/manifests/application_manifest.rb"
      m.directory "app/manifests/templates"
      m.file "manifests/templates/passenger.vhost.erb", "app/manifests/templates/passenger.vhost.erb"
      m.file "manifests/templates/README", "app/manifests/templates/README"

      # config
      m.directory "config/deploy"
      stages = []
      for @host in DEFAULT_DOMAINS.keys
        m.directory "config/deploy/#{@host}"
        m.directory "config/deploy/local/#{@host}"
        m.template "config/deploy/moonshine_host.yml", "config/deploy/#{@host}/moonshine.yml"
        m.template "config/deploy/deploy.host.rb.erb", "config/deploy/#{@host}/deploy.rb", 
          :assigns => { :host => "#{name}.#{domain}" }
        for local in [ true, false ]
          for @stage in %w(prod staging dev)
            stages << "#{@host}/#{'local/' if local}#{@stage}"
            m.template "config/deploy/moonshine_stage.yml", 
              "config/deploy/#{'local/' if local}#{@host}/#{@stage}_moonshine.yml", 
              :assigns => { :domain => domain, :host => @host, :stage => @stage, :local => local }
          end
        end
      end
      m.template "config/deploy.rb.erb", "config/deploy.rb", :assigns => { :stages => stages }
    end
  end
end
