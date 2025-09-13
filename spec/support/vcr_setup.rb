require "vcr"
require "webmock/rspec"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into(:webmock)
  config.configure_rspec_metadata!
  config.filter_sensitive_data("<EUPAGO_CLIENT_ID>") { ENV["EUPAGO_CLIENT_ID"] }
  config.filter_sensitive_data("<EUPAGO_CLIENT_SECRET>") { ENV["EUPAGO_CLIENT_SECRET"] }
  config.filter_sensitive_data("<EUPAGO_API_KEY>") { ENV["EUPAGO_API_KEY"] }
  config.default_cassette_options = { record: :once }

  config.before_record do |interaction|
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
      "Referrer-Policy",
      "Accept",
      "Content-Length",
      "Accept-Encoding",
    ]

    interaction.response.headers.select! { |key, _| allowed_headers.include?(key) }
    interaction.request.headers.select! { |key, _| allowed_headers.include?(key) }

    filtered_response_sensitive_data = [
      "subscriptionID",
      "referenceSubs",
      "redirectUrl",
      "access_token",
    ]

    response_body = begin
      JSON.parse(interaction.response.body)
    rescue
      {}
    end

    filtered_response_sensitive_data.each do |data|
      if response_body.key?(data)
        response_body[data] = "<FILTERED>"
      end
    end

    interaction.response.body = response_body.to_json
  end
end
