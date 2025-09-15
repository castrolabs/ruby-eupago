require_relative 'lib/ruby-eupago/version'

Gem::Specification.new do |spec|
  spec.name = 'ruby-eupago'
  spec.version     = EuPago::Version::STRING
  spec.date        = '2025-09-10'
  spec.summary     = 'Unofficial Ruby SDK for EuPago payment gateway.'
  spec.description = 'A convenient, unofficial Ruby SDK for integrating with the EuPago payment gateway. Includes authentication helpers, VCR-based test suite, and a structure SDK.'
  spec.authors     = ['Alexandro Castro']
  spec.email       = 'alexoliveira7x@gmail.com'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.0.0'
  spec.require_paths = ['lib']
  spec.files = Dir['{lib}/**/*'] + ['README.md', 'CHANGELOG.md', 'ruby-eupago.gemspec']

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
