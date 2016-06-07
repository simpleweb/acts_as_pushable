require 'rails_helper'

RSpec.describe ActsAsPushable::Pushable do
  context 'given an user with devices' do
    before do
      @user = User.create!
      @ios_token = SecureRandom.uuid
      @android_token = SecureRandom.uuid

      @user.add_device({
        token: @ios_token,
        platform: "ios",
        platform_version: "9.3",
        push_environment: "development",
      })

      @user.add_device({
        token: @android_token,
        platform: "android",
        platform_version: "4.4",
        push_environment: "development",
      })
    end

    context '#devices' do
      it 'returns an array of all devices' do
        expect(@user.devices.size).to eq(2)
        expect(@user.devices[0].token).to eq(@ios_token)
        expect(@user.devices[1].token).to eq(@android_token)
        expect(@user.devices[0].token).to be_kind_of(String)
        expect(@user.devices[1].token).to be_kind_of(String)
      end
    end

    context '#ios_devices' do
      it 'returns an array of only ios devices' do
        expect(@user.ios_devices.size).to eq(1)
        expect(@user.ios_devices[0].token).to eq(@ios_token)
        expect(@user.ios_devices[0].token).to be_kind_of(String)
      end
    end

    context '#android_devices' do
      it 'returns an array of only android devices' do
        expect(@user.android_devices.size).to eq(1)
        expect(@user.android_devices[0].token).to eq(@android_token)
        expect(@user.android_devices[0].token).to be_kind_of(String)
      end
    end

    context '#add_device' do
      it 'returns the device of only android devices' do
        expect(@user.android_devices.size).to eq(1)
        expect(@user.android_devices[0].token).to eq(@android_token)
        expect(@user.android_devices[0].token).to be_kind_of(String)
      end
    end

    context '#send_push_notification' do
      it 'calls send_push_notification on each device' do
        send_push_notification_count = 0
        allow_any_instance_of(ActsAsPushable::Device).to receive(:send_push_notification) { send_push_notification_count += 1 }
        @user.send_push_notification(title: 'My App', message: 'this is a test')
        expect(send_push_notification_count).to eq(2)
      end
    end

    context 'when the user has no devices' do
      before do
        @user = User.create!
      end

      context 'given valid parameters' do
        before do
          @params = {
            token: SecureRandom.uuid,
            platform: "ios",
            platform_version: "9.3",
            push_environment: "development",
          }
        end

        it '#add_device returns true' do
          result = @user.add_device(@params)
          expect(result).to be_kind_of(ActsAsPushable::Device)
        end

        it '#add_device returns the device' do
          result = @user.add_device(@params)
          expect(result).to be_kind_of(ActsAsPushable::Device)
        end
      end

      context 'given invalid parameters' do
        before do
          @params = {
            platform_version: "9.3",
            push_environment: "development",
          }
        end

        it '#add_device returns false' do
          result = @user.add_device(@params)
          expect(result).to eq(false)
          expect(@user.errors.full_messages).to eq([
            "Devices token can't be blank",
            "Devices platform can't be blank",
          ])
        end

        it '#add_device! raises an exception' do
          expect { @user.add_device!(@params) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Token can't be blank, Platform can't be blank")
        end
      end
    end
  end
end
