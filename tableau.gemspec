$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tableau/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tableau"
  s.version     = Tableau::VERSION
  s.authors     = ["Matt Ryder"]
  s.email       = ["matt@mattryder.co.uk"]
  s.homepage    = "http://www.github.com/MattRyder/tableau"
  s.summary     = "Parses, analyses and creates Timetables for Staffordshire University students."
  s.description = s.summary << "Handles both Course and individual Module timetables."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "nokogiri"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-spork"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "debugger"

end
