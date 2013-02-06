require 'spec_helper'

describe Magnetize do
  describe '.new' do
    it 'instantiates an instance of Magento' do
      expect(Magnetize.new).to be_a Magnetize::Magento
    end
  end
end
