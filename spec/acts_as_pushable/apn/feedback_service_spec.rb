require 'rails_helper'

RSpec.describe ActsAsPushable::APN::FeedbackService do
  describe '#run' do
    before do
      user = User.create!
      @device = ActsAsPushable::Device.create!({
        token: "abc123",
        platform: 'ios',
        platform_version: '9.3',
        push_environment: 'development',
        parent: user,
      })
    end

    it 'invaidates old devices' do
      Timecop.freeze(Time.parse('2016-01-01')) do
        allow_any_instance_of(Houston::Client).to receive(:devices).and_return(["abc123"])
        ActsAsPushable::APN::FeedbackService.run
        @device.reload
        expect(@device.invalidated_at).to eq(Time.current)
      end
    end
  end
end




