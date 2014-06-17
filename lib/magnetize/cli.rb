require 'thor'

module Magnetize
  class CLI < Thor
    default_task :help

    desc 'to_magento', 'Write Magento XML from TOML config'
    method_option :type,   :type =>  :string,  :required => false, :desc => 'Type of Magento config (e.g. app, errors). TOML is pulled from this prefix.' # ['app', 'errors']
    method_option :input,  :type =>  :string,  :required => false, :desc => 'Path to input TOML file' # local.toml
    method_option :output, :type =>  :string,  :required => false, :desc => 'Path to output XML file' # app/etc/local.xml
    method_option :force,  :type =>  :boolean, :required => false, :desc => 'Overwrite existing output file'
    method_option :dir,    :type =>  :string,  :required => false, :desc => 'Magento directory', :default => '.'
    def to_magento
      unless options[:type] && options[:input] && options[:output]
        Magnetize::Convert.new.to_magento write: true
      else
        Magnetize::Convert.new.to_magento write: true, types: { options[:type] => { :magento => options[:output], :toml => options[:input] }}
      end

    end

    desc 'to_toml', 'Write TOML from existing Magento config'
    method_option :type,   :type => :string,  :required => false, :desc => 'Type of Magento config (e.g. app, errors). Used as prefix in TOML.' # ['app', 'errors']
    method_option :input,  :type => :string,  :required => false, :desc => 'Path to input XML file' # app/etc/local.xml
    method_option :output, :type => :string,  :required => false, :desc => 'Path to output TOML file' # local.toml
    method_option :force,  :type => :boolean, :required => false, :desc => 'Overwrite existing output file'
    method_option :dir,    :type => :string,  :required => false, :desc => 'Magento directory', :default => '.'
    def to_toml
      Dir.chdir(options[:dir]) do
        unless options[:type] && options[:input] && options[:output]
          Magnetize::Convert.new.to_toml write: true
        else
          Magnetize::Convert.new.to_toml write: true, types: { options[:type] => { :magento => options[:input], :toml => options[:output] }}
        end
      end
    end

  end
end
