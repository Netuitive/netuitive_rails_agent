Gem::Specification.new do |s|
  s.name        = 'netuitive_rails_agent'
  s.version     = '0.9.0'
  s.date        = '2015-10-26'
  s.summary     = "Submits rails metrics to netuitive's api"
  s.description = "temp description"
  s.authors     = ["John King"]
  s.email       = 'jking@netuitive.com'
  files = Dir['lib/**/*.{rb}'] + Dir['lib/*.{rb}'] + Dir['config/*.{yml}']
  s.files       = files
  s.homepage    =
    'http://rubygems.org/gems/netuitive_rails_agent'
  s.license       = 'Apache v2.0'
  s.add_runtime_dependency 'netuitive_ruby_api', '>= 0.9.0'
end
