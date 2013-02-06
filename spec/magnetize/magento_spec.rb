require 'spec_helper'

describe Magnetize::Magento do
  before { ENV['magento_administrator_given_name'] = 'Allen' }

  let(:magento) { Magnetize::Magento.new }

  describe '.method_missing' do
    context 'when valid' do
      it { expect(magento.administrator_given_name).to eq 'Allen' }
    end
  end
end
