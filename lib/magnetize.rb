require 'magnetize/version'
require 'magnetize/magento'

module Magnetize
  class << self
    def new
      Magnetize::Magento.new
    end
  end
end
