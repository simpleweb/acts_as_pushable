module ActsAsPushable
  class Notification
    def initialize(device:, message:, **options)
      @device  = device
      @message = message
      @options = options
    end

    def self.send(device:, message:, **options)
      self.new(device: device, message: message, **options).perform
    end

    private

    attr_accessor :device, :message, :options

    def default_payload
      {
        popup: true,
        popup_title: nil,
        popup_body: nil,
        popup_type: 'alert',
        popup_ok_button_text: 'Ok',
        popup_cancel_button_text: 'Cancel',
        navigate_to_view: nil,
        navigate_to_view_as_modal: true,
        navigate_to_view_parameters: {},
      }
    end

    def environment
      device.push_environment
    end

    def payload
      payload = default_payload.keys.map do |key|
        [key, options.delete(key) || default_payload[key]]
      end.to_h

      payload.merge(options)
    end
  end
end
