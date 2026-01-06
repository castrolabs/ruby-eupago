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

    # Only keep allowed headers
    interaction.response.headers.select! { |key, _| allowed_headers.include?(key) }
    interaction.request.headers.select! { |key, _| allowed_headers.include?(key) }

    filtered_response_sensitive_data = [
      "subscriptionID",
      "referenceSubs",
      "redirectUrl",
      "access_token",
      "transactionID",
      "reference",
      "trid",
      "iban",
      "bic",
      "authorizationId",
      "referencia",
    ]

    response_body = begin
      JSON.parse(interaction.response.body)
    rescue
      {}
    end

    # Recursively filter sensitive data in response body
    def filter_sensitive_data_recursive(obj, sensitive_keys)
      case obj
      when Hash
        obj.each do |key, value|
          if sensitive_keys.include?(key)
            obj[key] = "FILTERED"
          else
            filter_sensitive_data_recursive(value, sensitive_keys)
          end
        end
      when Array
        obj.each { |item| filter_sensitive_data_recursive(item, sensitive_keys) }
      end
      obj
    end

    filter_sensitive_data_recursive(response_body, filtered_response_sensitive_data)
    interaction.response.body = response_body.to_json

    # Protect dynamic URL segments
    if interaction.request.uri.match?(%r{(creditcard|directdebit)/payment/[^/]+})
      interaction.request.uri.gsub!(%r{(creditcard|directdebit)/payment/[^/]+}, '\1/payment/FILTERED')
    end

    if interaction.request.uri.match?(%r{references/info\?reference=[^&]+})
      interaction.request.uri.gsub!(%r{references/info\?reference=[^&]+}, "references/info?reference=FILTERED")
    end
  end
end
