require 'gcm'

module ActsAsPushable
  module GCM
    class Notification
      def self.send(device:, title:, message:, **options)
        payload = {
          popup: options.fetch("popup", true),
          popup_title: options.fetch("popup_title", nil),
          popup_body: options.fetch("popup_body", nil),
          popup_type: options.fetch("popup_type", 'alert'),
          popup_ok_button_text: options.fetch("popup_ok_button_text", 'Ok'),
          popup_cancel_button_text: options.fetch("popup_cancel_button_text", 'Cancel'),
          navigate_to_view: options.fetch("navigate_to_view", nil),
          navigate_to_view_as_modal: options.fetch("navigate_to_view_as_modal", true),
          navigate_to_view_parameters: options.fetch("navigate_to_view_parameters", {}),
        }

        gcm = ::GCM.new(ActsAsPushable.configuration.gcm_key)

        gcm_options = {
          data: {
            title: title,
            message: message,
          }.merge(payload)
        }

        response = gcm.send([device.token], gcm_options)
        if response[:not_registered_ids].include? device.token
          device.update_attribute 'invalidated_at', Time.now
        end
      end
    end
  end
end
