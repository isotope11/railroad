require 'rubygems'
SPEC = Gem::Specification.new do |s|
  s.name         = "isotope-railroad"
  s.version      = "0.6.0"
  s.author       = "Javier Smaldone"
  s.email        = "javier@smaldone.com.ar"
  s.homepage     = "http://github.com/isotope11"
  s.rubyforge_project = "railroad"
  s.platform     = Gem::Platform::RUBY
  s.summary      = "A DOT diagram generator for Ruby on Rails applications"
  s.files        = Dir.glob("lib/railroad/*.rb") + 
                   ["ChangeLog", "COPYING", "isotope-railroad.gemspec"]
  s.bindir       = "bin"
  s.executables  = ["railroad"]
  s.default_executable = "railroad"
  s.has_rdoc     = true
  s.extra_rdoc_files = ["README", "COPYING"]

  s.add_development_dependency "pry"
end
