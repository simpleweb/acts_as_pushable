require 'acts_as_pushable/version'
require 'acts_as_pushable/configuration'

require 'acts_as_pushable/active_record/device.rb'
require 'acts_as_pushable/notification'
require 'acts_as_pushable/pushable'

require 'acts_as_pushable/apn/notification'
require 'acts_as_pushable/apn/feedback_service'
require 'acts_as_pushable/gcm/notification'

module ActsAsPushable
  LOCK = Mutex.new

  class << self
    def configure(config_hash=nil)
      if config_hash
        config_hash.each do |k,v|
          configuration.send("#{k}=", v) rescue nil if configuration.respond_to?("#{k}=")
        end
      end

      yield(configuration) if block_given?
    end

    def configuration
      @configuration = nil unless defined?(@configuration)
      @configuration || LOCK.synchronize { @configuration ||= ActsAsPushable::Configuration.new }
    end
  end
end
