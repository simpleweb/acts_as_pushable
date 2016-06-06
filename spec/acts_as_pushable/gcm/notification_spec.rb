require 'rails_helper'

RSpec.describe ActsAsPushable::GCM::Notification do
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
        expect_any_instance_of(GCM).to receive(:send).once.and_return({ not_registered_ids: [] })
        ActsAsPushable::GCM::Notification.send(device: @device, title: 'My App', message: 'this is a test', popup_title: "this is a test")
      end

      it 'can invalidate a device' do
        Timecop.freeze(Time.parse('2016-01-01')) do
          expect_any_instance_of(GCM).to receive(:send).once.and_return({ not_registered_ids: [@device.token] })
          ActsAsPushable::GCM::Notification.send(device: @device, title: 'My App', message: 'this is a test', popup_title: "this is a test")
          @device.reload
          expect(@device.invalidated_at).to eq(Time.now)
        end
      end
    end
  end
end
