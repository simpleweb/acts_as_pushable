$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_pushable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_pushable"
  s.version     = ActsAsPushable::VERSION
  s.authors     = ["Adam Butler"]
  s.email       = ["adam@lab.io"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ActsAsPushable."
  s.description = "TODO: Description of ActsAsPushable."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0.beta4", "< 5.1"

  s.add_development_dependency "sqlite3"
end
