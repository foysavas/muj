Gem::Specification.new do |s|
  s.name        = "muj"
  s.version     = "0.0.3"
  s.date        = "2011-11-29"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Foy Savas"]
  s.email       = "foy@sav.as"
  s.homepage    = "http://github.com/foysavas/muj"
  s.summary     = %q{Muj is Mustache.js for Ruby and your command line.}
  s.description = %q{Sometimes one implementation (in Javascript) is just better. Also checkout muj-java via Maven.}
  s.add_runtime_dependency 'tilt'
  s.add_development_dependency 'therubyracer'
  s.add_development_dependency 'therubyrhino'
  s.files       = %w( Rakefile ) 
  s.files      += Dir.glob("lib/**/*")
  s.files      += Dir.glob("bin/**/*")
  s.executables = %w( muj )
  s.require_paths = ["lib"]
end
