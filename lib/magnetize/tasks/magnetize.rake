namespace :magnetize do
  desc 'Push local TOML config to remote Magento installation as Magento config file format'
  task :push do
    Dir.chdir(fetch(:magnetize_dir)) do
      on roles fetch(:magnetize_roles), in: :parallel do
        config = Magnetize::Convert.new.to_magento({
          :write => false,
          :types => {
            'app' => {
              :magento => "#{fetch(:magnetize_appxml_path)}/local.xml",
              :content => IO.read(fetch(:magnetize_toml))
            },
            'errors' => {
              :magento => "#{fetch(:magnetize_errorsxml_path)}/local.xml",
              :content => IO.read(fetch(:magnetize_toml))
            }
          }
        })
        config.each do |path, config|
          upload! StringIO.new(config), "#{shared_path}/#{path}"
        end
      end
    end
  end

  desc 'Pull remote Magento config to local TOML config'
  task :pull do
    Dir.chdir(fetch(:magnetize_dir)) do
      on primary fetch(:magnetize_roles) do
        within "#{shared_path}" do
          config = Magnetize::Convert.new.to_toml({
            :write => false,
            :types => {
              'app' => {
                :content => capture(:cat, "#{fetch(:magnetize_localxml_path)}/local.xml"),
                :toml => nil
              },
              'errors' => {
                :content => capture(:cat, "#{fetch(:magnetize_errorsxml_path)}/local.xml"),
                :toml => nil
              }
            }
          })
          run_locally do
            # yeah sooo, welcome to my nightmare. Capistrano v3's ask method doesn't cut it for this use case.
            if File.exists?(fetch(:magnetize_toml)) && !fetch(:magnetize_force)
              fail "#{fetch(:magnetize_dir)}/#{fetch(:magnetize_toml)} already exists, remove it or set :magnetize_force, true"
            elsif File.exists?(fetch(:magnetize_toml)) && fetch(:magnetize_force)
              info "#{fetch(:magnetize_dir)}/#{fetch(:magnetize_toml)} already exists - Forced overwriting (:magnetize_force is true)"
            end
            if !File.exists?(fetch(:magnetize_toml)) || fetch(:magnetize_force)
              File.open(fetch(:magnetize_toml), 'w') {|f| f.write( config.values.join ) }
              info "#{fetch(:magnetize_dir)}/#{fetch(:magnetize_toml)} has been written"
            end
          end
        end
      end
    end
  end

end

namespace :load do
  task :defaults do

    set :magnetize_roles, :app
    set :magnetize_dir, '.'
    set :magnetize_appxml_path, 'app/etc'
    set :magnetize_errorsxml_path, 'errors'
    set :magnetize_toml, 'config.toml'
    set :magnetize_force, false

  end
end
