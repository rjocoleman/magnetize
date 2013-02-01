require 'magnetize'

require 'rspec'

RSpec.configure do |configuration|
  configuration.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
