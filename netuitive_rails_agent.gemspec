Gem::Specification.new do |s|
  s.name        = 'netuitive_rails_agent'
  s.version     = '0.9.6'
  s.date        = '2015-12-07'
  s.summary     = "Rails metrics for Netuitive's API"
  s.description = "Automatically generates Rails metrics for submission to Netuitive's API"
  s.authors     = ["John King"]
  s.email       = 'jking@netuitive.com'
  files = Dir['lib/**/*.{rb}'] + Dir['lib/*.{rb}'] + Dir['config/*.{yml}'] + Dir['./LICENSE'] + Dir['log/*'] + Dir['./README.md']
  s.files       = files
  s.homepage    =
    'http://rubygems.org/gems/netuitive_rails_agent'
  s.license       = 'Apache v2.0'
  s.add_runtime_dependency 'netuitive_ruby_api', '>= 0.9.0'
end
