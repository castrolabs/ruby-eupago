require_relative 'lib/ruby_eupago/version'

Gem::Specification.new do |spec|
  spec.name = 'ruby_eupago'
  spec.version     = EuPago::Version::STRING
  spec.date        = '2025-09-10'
  spec.summary     = 'Eupago Ruby SDK'
  spec.description = 'Eupago Ruby SDK'
  spec.authors     = ['Alexandro Castro']
  spec.email       = 'alexoliveira7x@gmail.com'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.0.0'
  spec.require_paths = ['lib']
  spec.files = Dir['{lib}/**/*'] + ['README.md', 'CHANGELOG.md', 'ruby_eupago.gemspec']

  spec.add_dependency 'httparty', '~> 0.23.1'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake', '~> 13.1.0'
  spec.add_development_dependency 'rubocop', '~> 1.59'
  spec.add_development_dependency 'rubocop-shopify', '~> 2.14'
  spec.add_development_dependency 'simplecov', '0.17.1'
  spec.add_development_dependency 'faker', '~> 3.5.2'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
