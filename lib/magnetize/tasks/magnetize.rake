namespace :magnetize do
  desc 'Push local TOML config to remote Magento installation as Magento config file format'
  task :push do
    Dir.chdir(fetch(:magnetize_dir)) do
      on roles fetch(:magnetize_roles), in: :parallel do
        options = fetch(:magnetize_opts)
        unless options[:type] && options[:input] && options[:output]
          config = Magnetize::Convert.new.to_magento write: false
        else
          config = Magnetize::Convert.new.to_magento write: false, types: { options[:type] => { :magento => options[:input], :toml => options[:output] }}
        end
        config.each do |path, config|
          upload! StringIO.new(config), "#{shared_path}/#{path}"
        end
      end
    end
  end

  desc 'Pull remote Magento config to local TOML config'
  task :pull do
    Dir.chdir(fetch(:magnetize_dir)) do
      on primary(fetch(:magnetize_roles)), in: :sequence do
        within "#{shared_path}" do
          app = capture(:cat, "#{fetch(:magnetize_localxml_path)}/local.xml")
          errors = capture(:cat, "#{fetch(:magnetize_errorsxml_path)}/local.xml")
          config = Magnetize::Convert.new.to_toml( :write => true, types: { 'app' => { :output => "#{:magnetize_dir}/config.toml", :content => app }, 'errors' => { :output => "#{:magnetize_dir}/config.toml", :content => errors }})
        end
      end
    end
  end

end

namespace :load do
  task :defaults do

    set :magnetize_roles, :app
    set :magnetize_opts, {}
    set :magnetize_dir, '.'
    set :magnetize_localxml_path, 'app/etc'
    set :magnetize_errorsxml_path, 'errors'

  end
end
