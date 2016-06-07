module ActsAsPushable
  class Configuration
    attr_accessor :apn_development_certificate_path, :apn_production_certificate_path, :gcm_key

    def initialize
      self.apn_development_certificate_path = Rails.root.join('config', 'acts_as_pushable', 'apn', 'development.pem')
      self.apn_production_certificate_path = Rails.root.join('config', 'acts_as_pushable', 'apn', 'production.pem')
    end

    def apn_development_certificate_file
      File.read(apn_development_certificate_path)
    end

    def apn_production_certificate_file
      File.read(apn_production_certificate_path)
    end
  end
end
