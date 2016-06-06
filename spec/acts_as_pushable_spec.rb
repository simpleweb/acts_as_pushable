require 'rails_helper'

RSpec.describe ActsAsPushable do
  describe '#configure' do
    it 'accepts a block' do
      ActsAsPushable.configure do |config|
        config.apn_development_certificate_path = 'block'
      end
      expect(ActsAsPushable.configuration.apn_development_certificate_path).to eq('block')
    end

    it 'accepts a hash' do
      ActsAsPushable.configure({apn_development_certificate_path: 'hash'})
      expect(ActsAsPushable.configuration.apn_development_certificate_path).to eq('hash')
    end
  end
end
