require 'houston'

module ActsAsPushable
  module APN
    class Notification
      def self.send(device:, message:, **options)
        development_apn = Houston::Client.development
        production_apn = Houston::Client.production

        development_apn.certificate = ActsAsPushable.configuration.apn_development_certificate_file
        production_apn.certificate = ActsAsPushable.configuration.apn_production_certificate_file

        payload = {
          popup: options.fetch('popup', true),
          popup_title: options.fetch('popup_title', nil),
          popup_body: options.fetch('popup_body', nil),
          popup_type: options.fetch('popup_type', 'alert'),
          popup_ok_button_text: options.fetch('popup_ok_button_text', 'Ok'),
          popup_cancel_button_text: options.fetch('popup_cancel_button_text', 'Cancel'),
          navigate_to_view: options.fetch('navigate_to_view', nil),
          navigate_to_view_as_modal: options.fetch('navigate_to_view_as_modal', true),
          navigate_to_view_parameters: options.fetch('navigate_to_view_parameters', {}),
        }

        notification = Houston::Notification.new(device: device.token)
        notification.alert = message
        notification.badge = options.fetch('count', nil)
        notification.custom_data = payload

        if device.push_environment == 'development'
          development_apn.push(notification)
        else
          production_apn.push(notification)
        end
      end
    end
  end
end
