require 'bundler'
require 'bundler/gem_tasks'

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task test: :spec
task default: :spec

namespace :documentation do
  require 'yard'

  YARD::Rake::YardocTask.new do |task|
    task.files   = %w(README.md LICENSE lib/**/*.rb)
    task.options = %w(--output-dir doc/yard --markup markdown)
  end
end
