module Magnetize
  class Magento
    OPTIONS = %w(
      administrator_given_name
      administrator_surname
      administrator_email
      administrator_username
      administrator_password

      cache_backend
      cache_slow_backend
      cache_slow_backend_store_data
      cache_auto_refresh_fast_cache

      cache_memcached_servers_server_host
      cache_memcached_servers_server_port
      cache_memcached_servers_server_persistent
      cache_memcached_servers_server_weight
      cache_memcached_servers_server_timeout
      cache_memcached_servers_server_retry_interval
      cache_memcached_servers_server_status

      cache_memcached_compression
      cache_memcached_cache_dir
      cache_memcached_hashed_directory_level
      cache_memcached_hashed_directory_umask
      cache_memcached_file_name_prefix

      database_read_name
      database_read_hostname
      database_read_username
      database_read_password

      database_write_name
      database_write_hostname
      database_write_username
      database_write_password

      database_table_prefix

      encryption_key

      remote_addr_headers_header1
      remote_addr_headers_header2

      report_action
      report_subject
      report_email_address
      report_trash

      session_save
      session_save_path
      session_cache_limiter

      skin
    )

    def method_missing(method_name)
      option = method_name.to_s

      if OPTIONS.include? option
        self.class.class_eval do
          define_method method_name do
            ENV["magento_#{method_name}"]
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

    def save_errors(path=nil)
      File.open "#{path ? path : Dir.pwd}/errors/local.xml", 'w+' do |file|
        file.write to_xml
      end
    end

    def save(path=nil)
      if !File.directory? "#{path ? path : Dir.pwd}/errors"
        Dir.mkdir "#{path ? path : Dir.pwd}/errors"
      end

      %w(local.xml errors/local.xml).each do |filename|
        File.open "#{path ? path : Dir.pwd}/#{filename}", 'w+' do |file|
          file.write to_xml(filename)
        end
      end

      "#{path ? path : Dir.pwd}/local.xml"
    end
  end
end
