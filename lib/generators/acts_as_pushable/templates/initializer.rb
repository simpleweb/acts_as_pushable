ActsAsPushable.configure do |config|
  # Defaults
  # config.apn_development_certificate_path = Rails.root.join('config', 'acts_as_pushable', 'apn', 'development.pem')
  # config.apn_production_certificate_path = Rails.root.join('config', 'acts_as_pushable', 'apn', 'production.pem')

  config.gcm_key = "replace_me_with_your_gcm_api_key"
end
