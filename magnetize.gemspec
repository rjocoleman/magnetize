# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magnetize/version'

Gem::Specification.new do |spec|
  spec.name          = 'magnetize'
  spec.version       = Magnetize::VERSION
  spec.authors       = ['Robert Coleman']
  spec.email         = ['github@robert.net.nz']
  spec.summary       = %q{CLI/library for generating Magento local.xml files}
  spec.description   = %q{CLI/library for generating Magento local.xml files}
  spec.homepage      = 'https://github.com/rjocoleman/magnetize/'
  spec.license       = 'MIT'

  spec.files         = Dir.glob("{bin,lib}/**/*") + %w(LICENSE.txt README.md)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-plus'

  spec.add_dependency 'thor', '~> 0.18'
  spec.add_dependency 'toml', '~> 0.1'
  spec.add_dependency 'activesupport', '~> 4.0'
  spec.add_dependency 'gyoku', '~> 1.1'
  spec.add_dependency 'deep_merge', '~> 1.0'
end
