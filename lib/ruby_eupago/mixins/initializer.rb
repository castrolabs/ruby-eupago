require "httparty"

module EuPago
  module Mixins
    module Client
      def initialize(config)
        options = Hash[config.map { |(k, v)| [k.to_sym, v] }]
        @base_url = options[:base_url] || base_url(options[:append_base_url])
      end

      def base_url(append_base_url = "")
        if ENV["EUPAGO_SANDBOX"]
          "https://sandbox.eupago.pt/api#{append_base_url}"
        else
          "https://clientes.eupago.pt/api#{append_base_url}"
        end
      end

      def get(api_url, query: {})
        result = HTTParty.get(
          api_url,
          base_uri: @base_url,
          format: :json,
          headers: {
            "Authorization" => ENV["EUPAGO_API_KEY"].to_s,
            "Content-Type" => "application/json",
            "Accept" => "application/json",
          },
          query: query,
        )

        parse_result(result)
      end

      def post(api_url, body: {})
        result = HTTParty.post(
          api_url,
          base_uri: @base_url,
          format: :json,
          headers: {
            "Authorization" => ENV["EUPAGO_API_KEY"].to_s,
            "Content-Type" => "application/json",
            "Accept" => "application/json",
          },
          body: body,
        )

        parse_result(result)
      end

      private

      def parse_result(result)
        if result.headers["content-type"] == "application/json"
          response = result.parsed_response
        else
          response = result.body
        end

        case result.code
        when 200
          result.parsed_response
        when 401
          raise EuPago::UnauthorizedError, "[Eupago SDK] Unauthorized: #{response}"
        when 400
          raise EuPago::BadRequestError, "[Eupago SDK] Bad Request: #{response}"
        when 404
          raise EuPago::NotFoundError, "[Eupago SDK] Not Found: #{response}"
        when 403
          raise EuPago::ForbiddenError, "[Eupago SDK] Forbidden: #{response}"
        else
          raise EuPago::ClientError, "[Eupago SDK] Error (#{result.code}): #{response}"
        end
      end
    end
  end

  class ClientError < StandardError; end
  class UnauthorizedError < StandardError; end
  class BadRequestError < StandardError; end
  class NotFoundError < StandardError; end
  class ForbiddenError < StandardError; end
end
