require "vcr"
require "webmock/rspec"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into(:webmock)
  config.configure_rspec_metadata!
  config.filter_sensitive_data("<EUPAGO_API_KEY>") { ENV["EUPAGO_API_KEY"] }
  config.default_cassette_options = { record: :once }
end
