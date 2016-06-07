module ActsAsPushable
  module Pushable
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_pushable(options = {})
        has_many :devices, as: :parent, class_name: 'ActsAsPushable::Device'
      end
    end

    def ios_devices
      devices.where(platform: 'ios')
    end

    def android_devices
      devices.where(platform: 'android')
    end

    def add_device(device_params)
      device = build_device(device_params)
      if device.save
        return device
      else
        device.errors.each do |attribute, message|
          errors.add(:devices, "#{attribute} #{message}")
        end
        return false
      end
    end

    def add_device!(device_params)
      device = build_device(device_params)
      device.save!
      return device
    end

    def send_push_notification(title:, message:, **options)
      devices.each do |device|
        device.send_push_notification(title: title, message: message, **options)
      end
    end

    private

    def build_device(device_params)
      self.devices.build(device_params)
    end

  end
end

ActiveRecord::Base.send :include, ActsAsPushable::Pushable
