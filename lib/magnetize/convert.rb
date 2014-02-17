require 'toml'
require 'active_support/core_ext/hash'
require 'gyoku'
require 'thor'
require 'deep_merge'

module Magnetize
  class Convert < Thor
    include Thor::Shell

    DEFAULTS = {
      :force => false,
      :write => false,
      :types => {
        'app' => {
          :magento => 'app/etc/local.xml',
          :toml => 'config.toml',
          :content => nil
        },
        'errors' => {
          :magento => 'errors/local.xml',
          :toml => 'config.toml',
          :content => nil
        }
      }
    }

    no_commands do
      def to_magento(options = {})
        options = DEFAULTS.deep_merge(options)
        result = {}
        options[:types].each do |type, config|
          input = File.expand_path(config[:toml])
          output = File.expand_path(config[:magento])
          hash = read_toml(input)
          xml = make_xml(hash[type.to_s])
          if options[:write]
            write(output, xml, options[:force])
          else
            result[config[:magento]] = xml
          end
        end
        return result unless options[:write]
      end

      def to_toml(options = {})
        options = DEFAULTS.deep_merge(options)
        result = {}
        options[:types].each do |type, config|
          input = File.expand_path(config[:magento])
          output = File.expand_path(config[:toml])
          if config[:content]
            xml = config[:content]
          else
            xml = IO.read(input)
          end
          hash = { type.to_s => read_xml(xml) }
          config = read_toml(output)
          config.merge!(hash)
          toml = make_toml(config)
          if options[:write]
            write(output, toml, options[:force])
          else
            result[config[:toml]] = toml
          end
        end
        return result unless options[:write]
      end

    end # no_commands

    private

    def read_toml(path)
      if File.exists?(path)
        TOML.load_file(path)
      else
        {}
      end
    end

    def make_toml(hash)
      TOML::Generator.new(hash).body
    end

    def read_xml(xml)
      replace_nil(Hash.from_xml(xml))
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

    def replace_nil(h)
      h.each_pair do |k,v|
        if v.is_a?(Hash)
          replace_nil(v)
        else
          h[k] = v.to_s if v.nil?
        end
      end
    end

  end
end
