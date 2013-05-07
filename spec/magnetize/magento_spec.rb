require 'spec_helper'

describe Magnetize::Magento do
  before do
    ENV['magento_database_read_hostname'] = 'localhost'
    ENV['magento_database_read_username'] = 'magento'
    ENV['magento_database_read_password'] = '?DWG,/2t*D;q^B73p2zi]9Ep776buF,i'
    ENV['magento_database_read_name']     = 'magento'

    ENV['magento_database_write_hostname'] = 'localhost'
    ENV['magento_database_write_username'] = 'magento'
    ENV['magento_database_write_password'] = '?DWG,/2t*D;q^B73p2zi]9Ep776buF,i'
    ENV['magento_database_write_name']     = 'magento'

    ENV['magento_encryption_key'] = '82ba7f3f9db9aec288ffbce1e0ad08e2'
  end

  let(:magento) { Magnetize::Magento.new }

  describe '.method_missing' do
    context 'when valid' do
      it { expect(magento.database_read_hostname).to eq 'localhost' }
    end
  end

  describe '.to_xml' do
    let(:configuration) {
      File.read "#{File.expand_path '.'}/spec/fixtures/local.xml"
    }

    context '' do
      it { expect(magento.to_xml('local.xml')).to eq configuration }
    end
  end

  describe '.save' do
    let(:configuration) {
      File.read "#{File.expand_path '.'}/spec/fixtures/local.xml"
    }

    let(:errors) {
      File.read "#{File.expand_path '.'}/spec/fixtures/errors/local.xml"
    }

    let(:path) { magento.save }

    after(:all) { File.delete path }

    context 'when path argument is valid' do
      it { expect(File.open(path, 'r') { |f| f.read }).to eq configuration }


    end
  end
end
