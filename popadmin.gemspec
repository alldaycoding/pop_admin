$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pop_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pop_admin"
  s.version     = PopAdmin::VERSION
  s.authors     = ["bacchir"]
  s.email       = ["bacchi.rafael@gmail.com"]
  s.homepage    = ""
  s.summary     = "Beautiful and flexible administration engine"
  s.description = "Beautiful and flexible administration engine"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.7"
  s.add_dependency "bootstrap-sass", "~> 3.3.7"
  s.add_development_dependency "sqlite3"
end
