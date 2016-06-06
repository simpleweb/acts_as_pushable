require 'rails_helper'

RSpec.describe ActsAsPushable::APN::Notification do
  context 'given a device' do
    before do
      @device = ActsAsPushable::Device.create({
        token: SecureRandom.uuid,
        platform: 'ios',
        platform_version: '9.3',
        push_environment: 'development',
      })
    end

    describe '#send' do
      it 'calls push on houston' do
        expect_any_instance_of(Houston::Client).to receive(:push).once
        ActsAsPushable::APN::Notification.send(device: @device, message: 'this is a test', popup_title: "this is a test")
      end

      context 'given a production device' do
        it 'calls push on houston' do
          @device.push_environment = 'production'
          expect_any_instance_of(Houston::Client).to receive(:push).once
          ActsAsPushable::APN::Notification.send(device: @device, message: 'this is a test', popup_title: "this is a test")
        end
      end
    end
  end
end
