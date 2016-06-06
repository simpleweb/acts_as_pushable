require 'houston'

module ActsAsPushable
  module APN
    class FeedbackService
      def run
        development_apn = Houston::Client.development
        production_apn = Houston::Client.production

        development_apn.certificate = File.read("#{Rails.root}/apn/development/client.pem")
        production_apn.certificate = File.read("#{Rails.root}/apn/production/client.pem")

        devices = development_apn.devices + production_apn.devices

        devices.each do |device|
          device = ActsAsPushable::Device.find_by_token(device)
          device.update_attribute('invalidated_at', Time.now) if device
        end
      end
    end
  end
end
