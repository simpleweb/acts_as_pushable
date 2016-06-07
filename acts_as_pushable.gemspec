$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'acts_as_pushable/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'acts_as_pushable'
  s.version     = ActsAsPushable::VERSION
  s.authors     = ['Adam Butler']
  s.email       = ['adam@simpleweb.co.uk']
  s.homepage    = 'https://github.com/simpleweb/acts_as_pushable'
  s.summary     = 'Add iOS & Android device and push notification support in your Rails application.'
  s.description = 'A gem for Ruby on Rails that makes managing devices and push notifications for both iOS and Android easy and reliably.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 5.0.0.beta4', '< 5.1'
  s.add_dependency 'houston'
  s.add_dependency 'gcm'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'simplecov'
end
