require 'gcm'

module ActsAsPushable
  module GCM
    class Notification < ActsAsPushable::Notification
      def perform
        response = client.send([device.token], gcm_options)
        if response[:not_registered_ids].include? device.token
          device.update_attribute 'invalidated_at', Time.current
        end
        response
      end

      private

      attr_accessor :title

      def client
        ::GCM.new(ActsAsPushable.configuration.gcm_key)
      end

      def gcm_options
        {
          data: {
            title: title,
            message: message,
          }.merge(payload)
        }
      end

      def title
        options.delete(:title)
      end
    end
  end
end
