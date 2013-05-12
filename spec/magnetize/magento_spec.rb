require 'spec_helper'

describe Magnetize::Magento do
  before do
    ENV['magento_default_read_hostname'] = 'localhost'
    ENV['magento_default_read_username'] = 'magento'
    ENV['magento_default_read_password'] = '?DWG,/2t*D;q^B73p2zi]9Ep776buF,i'
    ENV['magento_default_read_dbname']     = 'magento'

    ENV['magento_default_write_hostname'] = 'localhost'
    ENV['magento_default_write_username'] = 'magento'
    ENV['magento_default_write_password'] = '?DWG,/2t*D;q^B73p2zi]9Ep776buF,i'
    ENV['magento_default_write_dbname']     = 'magento'

    ENV['magento_crypt_key'] = '82ba7f3f9db9aec288ffbce1e0ad08e2'
  end

  let(:magento) { Magnetize::Magento.new }

  describe '.method_missing' do
    context 'when valid' do
      it { expect(magento.default_read_hostname).to eq 'localhost' }
    end
  end

  describe '.to_xml' do
    let(:configuration) {
      File.read "#{File.expand_path '.'}/spec/fixtures/app/etc/local.xml"
    }

    context '' do
      it { expect(magento.to_xml('app/etc/local.xml')).to eq configuration }
    end
  end

  describe '.save' do
    let(:configuration) {
      File.read "#{File.expand_path '.'}/spec/fixtures/app/etc/local.xml"
    }

    context 'configuration is valid' do
      it {
        magento.save

        expect(File.open('app/etc/local.xml', 'r') { |f| f.read }).to eq configuration
      }
    end
  end
end
