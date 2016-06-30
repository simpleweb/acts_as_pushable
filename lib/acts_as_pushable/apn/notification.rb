require 'houston'

module ActsAsPushable
  module APN
    class Notification < ActsAsPushable::Notification
      def perform
        client.push(notification)
      end

      private

      def client
        client             = Houston::Client.send(environment)
        client.certificate = certificate
        client
      end

      def certificate
        ActsAsPushable.configuration.send("apn_#{environment}_certificate_file")
      end

      def content_available
        options.delete(:content_available) || true
      end

      def count
        options.delete(:count)
      end

      def notification
        notification = Houston::Notification.new(device: device.token)
        notification.alert             = message
        notification.badge             = count
        notification.content_available = content_available
        notification.custom_data       = payload
        notification
      end
    end
  end
end
