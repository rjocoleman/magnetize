require 'spec_helper'

describe Magnetize::Magento do
  before do
    ENV['magento_database_hostname'] = 'localhost'
    ENV['magento_database_username'] = 'magento'
    ENV['magento_database_password'] = '?DWG,/2t*D;q^B73p2zi]9Ep776buF,i'
    ENV['magento_database_name']     = 'magento'
    ENV['magento_encryption_key']    = '82ba7f3f9db9aec288ffbce1e0ad08e2'
  end

  let(:magento) { Magnetize::Magento.new }

  describe '.method_missing' do
    context 'when valid' do
      it { expect(magento.database_hostname).to eq 'localhost' }
    end
  end

  describe '.to_xml' do
    let(:configuration) {
      File.read "#{File.expand_path '.'}/spec/fixtures/local.xml"
    }

    context '' do
      it { expect(magento.to_xml).to eq configuration }
    end
  end
end
