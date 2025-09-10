require_relative 'lib/eupago_ruby/version'

Gem::Specification.new do |spec|
  spec.name = 'eupago_ruby'
  spec.version     = EuPago::Version::STRING
  spec.date        = '2025-09-10'
  spec.summary     = 'Eupago Ruby SDK'
  spec.description = 'Eupago Ruby SDK'
  spec.authors     = ['Alexandro Castro']
  spec.email       = 'alexoliveira7x@gmail.com'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.0.0'
  spec.require_paths = ['lib']
  spec.files = Dir['{lib}/**/*'] + ['README.md', 'CHANGELOG.md', 'eupago_ruby.gemspec']

  spec.add_dependency 'httparty', '~> 0.23.1'

  spec.add_development_dependency 'minitest', '>= 5.15.0'
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency 'rake', '~> 13.1.0'
  spec.add_development_dependency 'rubocop', '~> 1.59'
  spec.add_development_dependency 'rubocop-shopify', '~> 2.14'
  spec.add_development_dependency 'simplecov', '0.17.1'
  spec.add_development_dependency 'mocha', '~> 2.7.1'
  spec.add_development_dependency 'faker', '~> 3.5.2'
end
