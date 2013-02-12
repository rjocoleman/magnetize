# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'magnetize/version'

Gem::Specification.new do |gem|
  gem.name        = 'magnetize'
  gem.version     = Magnetize::VERSION
  gem.authors     = ['Allen Goodman']
  gem.email       = ['allen@goodman.io']
  gem.description = %q{
    A Gem for creating a Magento configuration from environmental variables.
  }
  gem.summary     = %q{
    A Gem for creating a Magento configuration from environmental variables.
  }
  gem.homepage    = 'https://github.com/2a6U37Nn/magnetize'

  gem.add_development_dependency 'rake',      '~> 0'
  gem.add_development_dependency 'rspec',     '~> 2'
  gem.add_development_dependency 'simplecov', '~> 0'
  gem.add_development_dependency 'yard',      '~> 0'

  gem.files = `git ls-files`.split($/)

  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files  = gem.files.grep(%r{^spec/})

  gem.require_paths = ['lib']
end
