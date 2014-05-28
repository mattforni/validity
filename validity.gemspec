Gem::Specification.new do |s|
  s.name        = 'validity'
  s.version     = '1.0.2'
  s.date        = Date.today
  s.summary     = "Validates ActiveRecord models"
  s.description = "The beginning of a validation library"
  s.authors     = ["Matt Fornaciari"]
  s.email       = 'mattforni@gmail.com'
  s.files       = Dir[ File.join('lib', '**', '*.rb') ].reject { |p| File.directory? p }
  s.homepage    = 'http://rubygems.org/gems/validity'
  s.license     = 'MIT'
  s.add_runtime_dependency 'test-unit', '~> 2'
  s.add_development_dependency 'activerecord', '~> 4.1'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'rspec', '~> 2'
  s.post_install_message = "Happy testing!"
end

