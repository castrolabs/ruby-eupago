require_relative "../lib/ruby_eupago"
require_relative "support/vcr_setup"
require_relative "support/auth_spec_helper"
require_relative "support/subscription_spec_helper"
require_relative "support/payment_spec_helper"
require "webmock/rspec"

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def input(message)
  puts(message)
  $stdin.gets
end
