require 'toml'
require 'active_support/core_ext/hash'
require 'gyoku'
require 'thor'

module Magnetize
  class Convert < Thor
    include Thor::Shell
    
    DEFAULTS = {
      :force => false,
      :write => false,
      :types => {
        'app' => {
          :magento => 'app/etc/local.xml',
          :toml => 'config.toml'
        },
        'errors' => {
          :magento => 'errors/local.xml',
          :toml => 'config.toml'
        }
      }
    }
    
    no_commands do
      def to_magento(options = {})
        options = DEFAULTS.merge(options)
        result = {}
        options[:types].each do |type, config|
          input = File.expand_path(config[:toml])
          output = File.expand_path(config[:magento])
          hash = read_toml(input)
          xml = make_xml(hash[type.to_sym])
          if options[:write]
            write(output, xml, options[:force])
          else
            result[type] = xml
          end
        end
        return result unless options[:write]
      end
    
      def to_toml(options = {})
        options = DEFAULTS.merge(options)
        result = {}
        options[:types].each do |type, config|
          input = File.expand_path(config[:magento])
          output = File.expand_path(config[:toml])
          hash = { type.to_sym => read_xml(input) }
          toml = make_toml(hash)
          if options[:write]
            write(output, toml, options[:force])
          else
            result[type] = toml
          end
        end
        return result unless options[:write]
      end
      
    end # no_commands
    
    private
    
    def read_toml(path)
      TOML.load_file(path, symbolize_keys: true)
    end
    
    def make_toml(hash)
      TOML.dump(hash)
    end
    
    def read_xml(path)
      Hash.from_xml(IO.read(path))
    end
    
    def make_xml(hash)
      Gyoku.xml(hash, { :key_converter => :none, :builder => { :indent => 2 } })
    end
    
    def write(path, content, force=false)
      FileUtils.mkdir_p(File.dirname(path))
      unless force
        if File.exists?(path)
          say("#{path} already exists. ", :red)
          abort("----> Skipped #{File.basename(path)}") if no?("Overwrite? (y/N):", :yellow)
        end
      end
      File.open(path, 'w') {|f| f.write(content)}
      puts "----> Wrote #{File.basename(path)}"
    end
    
  end
end

# yuck, bad bad hack
module TOML
  class Dumper
    def to_toml(obj)
      case
      when obj.is_a?(Time)
        obj.strftime('%Y-%m-%dT%H:%M:%SZ')
      when obj.nil?
        obj = '""'
      else
        obj.inspect
      end
    end
  end
end
