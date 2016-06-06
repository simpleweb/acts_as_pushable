module ActsAsPushable
  class Device < ActiveRecord::Base
    belongs_to :parent, polymorphic: true

    validates :token, :platform, :valid_at, :parent, :platform_version, :push_environment, presence: true
    validates :token, uniqueness: true
    validates :active, inclusion: { in: [true, false] }

    before_validation :set_valid_at, on: :create

    scope :active, -> { where(invalidated_at: nil, active: true) }

    def ios?
      platform == 'ios'
    end

    def android?
      platform == 'android'
    end

    def deactivate
      self.update_attributes({
        active: false,
        deactivated_at: Time.now,
      })
    end

    def send_push_notification(message:, **options)
      case platform
      when 'ios'
        ActsAsPushable::APN::Notification.send(device: self, message: message, **options)
      when 'android'
        raise ArgumentError, 'missing keyword: title' unless options.key? :title
        ActsAsPushable::GCM::Notification.send(device: self, title: options[:title], message: message, **options)
      end
    end

    private

    def set_valid_at
      self.valid_at = Time.now
    end
  end
end
