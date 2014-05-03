Gem::Specification.new do |s|
  s.name        = 'validity'
  s.version     = '0.0.2'
  s.date        = Date.today
  s.summary     = "Validates ActiveRecord models"
  s.description = "The beginning of a validation library"
  s.authors     = ["Matt Fornaciari"]
  s.email       = 'mattforni@gmail.com'
  s.files       = ["lib/validity.rb", "lib/validity/active_record.rb"]
  s.homepage    = 'http://rubygems.org/gems/validity'
  s.license     = 'MIT'
  s.add_runtime_dependency 'test-unit', '~> 2'
  s.post_install_message = "Happy testing!"
end

