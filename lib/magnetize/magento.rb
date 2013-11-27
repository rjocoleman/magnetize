module Magnetize
  class Magento
    OPTIONS = %w(
      admin_routers_adminhtml_args_frontname

      cache_slow_backend

      cache_slow_backend_servers_server_host
      cache_slow_backend_servers_server_port
      cache_slow_backend_servers_server_persistent

      cache_fast_backend

      cache_fast_backend_servers_server_host
      cache_fast_backend_servers_server_port
      cache_fast_backend_servers_server_persistent

      cache_backend

      cache_memcached_servers_server_host
      cache_memcached_servers_server_port
      cache_memcached_servers_server_persistent

      cache_memcached_compression
      cache_memcached_cache_dir
      cache_memcached_hashed_directory_level
      cache_memcached_hashed_directory_umask
      cache_memcached_file_name_prefix

      default_read_dbname
      default_read_hostname
      default_read_username
      default_read_password

      default_write_dbname
      default_write_hostname
      default_write_username
      default_write_password

      default_setup_dbname
      default_setup_hostname
      default_setup_username
      default_setup_password

      default_backup_dbname
      default_backup_hostname
      default_backup_username
      default_backup_password
      
      db_table_prefix

      crypt_key

      remote_addr_headers_header1
      remote_addr_headers_header2

      session_save
      session_save_path
      session_cache_limiter
      
      errors_skin

      errors_report_action
      errors_report_subject
      errors_report_email_address
      errors_report_trash
    )

    def method_missing(method_name)
      option = method_name.to_s

      if OPTIONS.include? option
        self.class.class_eval do
          define_method method_name do
            if !ENV["magento_#{method_name}"].nil? &&  !ENV["magento_#{method_name}"].empty?
              ENV["magento_#{method_name}"]
            end
          end
        end

        send method_name
      else
        super
      end
    end

    def respond_to?(method_name)
      OPTIONS.include? method_name.to_s || super
    end

    def to_xml(template)
      erb = ERB.new File.read(
        "#{File.dirname(__FILE__)}/templates/#{template}.erb"
      )

      erb.result binding
    end
    
    def write_local(filepath,filename)
      File.open filepath, 'w+' do |file|
        file.write to_xml(filename)
      end
      puts "---> #{filename} magnetized."
    end

    def save(path=nil,overwrite=nil)
      %w(app app/etc errors).each do |directory|
        directory = Dir.pwd + "/#{directory}"
        if !Dir.exists? directory
          Dir.mkdir directory
        end
      end

      %w(app/etc/local.xml errors/local.xml).each do |filename|
        filepath = (path ? path : Dir.pwd) + "/#{filename}"
        if !File.exists? filepath or overwrite
          write_local(filepath,filename)
        else
          puts "#{filename} detected. Overwrite? (y/N)"
          case STDIN.getch.strip
          when 'Y', 'y', 'yes'
            write_local(filepath,filename)
          else
            puts "---> #{filename} cancelled."
          end
        end
        
      end
    end
  end
end
