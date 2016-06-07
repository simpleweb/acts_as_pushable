require 'rails_helper'

RSpec.describe ActsAsPushable::Device do
  context 'given a device' do
    before do
      user = User.create!
      @device = ActsAsPushable::Device.create!({
        token: SecureRandom.uuid,
        platform: "ios",
        platform_version: "9.3",
        push_environment: "development",
        parent: user,
      })
    end

    context '#ios?' do
      it 'returns true' do
        expect(@device.ios?).to eq(true)
      end
    end

    context '#android?' do
      it 'returns false' do
        expect(@device.android?).to eq(false)
      end
    end

    context '#deactivate' do
      it 'sets active to false' do
        expect(@device.active?).to eq(true)
        @device.deactivate
        expect(@device.active?).to eq(false)
      end

      it 'sets sets the deactivated time' do
        Timecop.freeze(Time.parse('2016-01-01')) do
          expect(@device.deactivated_at).to be_nil
          @device.deactivate
          expect(@device.deactivated_at).to eq(Time.now)
        end
      end
    end

    context '#send_push_notification' do
      before do
        user = User.create!
        @android_device = ActsAsPushable::Device.create!({
          token: SecureRandom.uuid,
          platform: "android",
          platform_version: "4.4",
          push_environment: "development",
          parent: user,
        })
      end

      it 'sends a notification' do
        expect(ActsAsPushable::APN::Notification).to receive(:send).with({ device: @device, message: 'this is a test', popup: true })
        @device.send_push_notification(message: 'this is a test', popup: true)
      end

      context 'given the android device' do
        it 'sends a notification' do
          expect(ActsAsPushable::GCM::Notification).to receive(:send).with({ device: @android_device, message: 'this is a test', title: 'My App', popup: true })
          @android_device.send_push_notification(message: 'this is a test', title: 'My App', popup: true)
        end

        context 'if the title is not given' do
          it 'raises an error' do
            expect {
              @android_device.send_push_notification(message: 'this is a test', popup: true)
            }.to raise_error(ArgumentError, 'missing keyword: title')
          end
        end
      end
    end
  end
end
