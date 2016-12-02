require 'houston'

module ActsAsPushable
  module APN
    class FeedbackService
      def self.run
        development_apn = Houston::Client.development
        production_apn = Houston::Client.production

        development_apn.certificate = ActsAsPushable.configuration.apn_development_certificate_file
        production_apn.certificate = ActsAsPushable.configuration.apn_production_certificate_file

        devices = development_apn.devices + production_apn.devices

        devices.each do |device|
          device = ActsAsPushable::Device.find_by_token(device.delete(' '))
          device.update_attribute('invalidated_at', Time.current) if device
        end
      end
    end
  end
end
