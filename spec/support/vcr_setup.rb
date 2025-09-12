require "vcr"
require "webmock/rspec"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into(:webmock)
  config.configure_rspec_metadata!
  config.filter_sensitive_data("<EUPAGO_CLIENT_ID>") { ENV["EUPAGO_CLIENT_ID"] }
  config.filter_sensitive_data("<EUPAGO_CLIENT_SECRET>") { ENV["EUPAGO_CLIENT_SECRET"] }
  config.default_cassette_options = { record: :once }

  config.before_record do |interaction|
    if interaction.request.uri.include?('/auth/token')
      interaction.response.body = JSON.generate({
        "transactionStatus": "Success", 
        "access_token": "FILTERED", 
        "token_type": "Bearer", 
        "expires_in": 432000
      })
    end

    allowed_headers = [
      "Server",
      "Date",
      "Content-Type",
      "Transfer-Encoding",
      "Connection",
      "X-Powered-By",
      "Expires",
      "Cache-Control",
      "Pragma",
      "Strict-Transport-Security",
      "X-Content-Type-Options",
      "X-Xss-Protection",
      "Referrer-Policy"
    ]
    
    interaction.response.headers.select! { |key, _| allowed_headers.include?(key) }
  end
end
