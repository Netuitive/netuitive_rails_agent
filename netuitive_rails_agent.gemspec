Gem::Specification.new do |s|
  s.name        = 'netuitive_rails_agent'
  s.version     = '1.2.0'
  s.date        = '2018-05-03'
  s.summary     = "Rails metrics for Netuitive's API"
  s.description = "Automatically generates Rails metrics for submission to Netuitive's API"
  s.authors     = ['John King']
  s.email       = 'jking@netuitive.com'
  files = Dir['lib/**/*.{rb}'] + Dir['lib/*.{rb}'] + Dir['config/*.{yml}'] + Dir['./LICENSE'] + Dir['log/*'] + Dir['./README.md']
  s.files       = files
  s.homepage    =
    'http://rubygems.org/gems/netuitive_rails_agent'
  s.license = 'Apache-2.0'
  s.add_runtime_dependency 'netuitive_ruby_api', '>= 1.0.1'
  s.add_development_dependency 'netuitived', '>= 1.0.1'
end
