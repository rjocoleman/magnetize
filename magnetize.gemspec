# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'magnetize/version'

Gem::Specification.new do |gem|
  gem.name    = 'magnetize'
  gem.version = Magnetize::VERSION

  gem.platform = Gem::Platform::RUBY

  gem.authors     = 'Allen Goodman'
  gem.email       = 'allen@goodman.io'
  gem.description = %q{CLI for generating Magento local.xml files.}
  gem.summary     = %q{CLI for generating Magento local.xml files.}
  gem.homepage    = 'https://github.com/prairie/magnetize'

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ['lib']

  gem.bindir      = 'bin'
  gem.executables = 'magnetize'

  gem.test_files = gem.files.grep(%r{^(spec|features)/})

  gem.has_rdoc         = true
  gem.extra_rdoc_files = ['README.md']
  gem.rdoc_options << '--title magnetize --main README.md -ri'

  gem.add_development_dependency 'aruba',     '~> 0'
  gem.add_development_dependency 'rake',      '~> 0'
  gem.add_development_dependency 'rspec',     '~> 2'
  gem.add_development_dependency 'simplecov', '~> 0'
  gem.add_development_dependency 'yard',      '~> 0'

  gem.add_runtime_dependency 'gli', '~> 2'
  gem.add_runtime_dependency 'dotenv', '~> 0.7'
  
end
