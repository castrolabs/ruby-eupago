require "httparty"

module EuPago
  module Mixins
    module Client
      def initialize(config = {})
        options = Hash[config.map { |(k, v)| [k.to_sym, v] }]
        @base_url = options[:base_url] || build_base_url
        @include_api_key = options.fetch(:include_api_key, false)
      end

      def build_base_url(append_base_url = "")
        if ENV["EUPAGO_PRODUCTION"]
          "https://clientes.eupago.pt/api#{append_base_url}"
        else
          "https://sandbox.eupago.pt/api#{append_base_url}"
        end
      end

      def get(api_url, query: {}, headers: {})
        result = HTTParty.get(
          api_url,
          base_uri: @base_url,
          format: :json,
          headers: build_headers(headers),
          query: query,
        )

        parse_result(result)
      end

      def post(api_url, body: {}, headers: {})
        kheader = build_headers(headers)
        kbody = kheader["Content-Type"] == "application/json" ? body.to_json : body

        result = HTTParty.post(
          api_url,
          base_uri: @base_url,
          format: :json,
          headers: kheader,
          body: kbody,
        )

        parse_result(result)
      end

      private

      def build_headers(additional_headers = {})
        headers = {
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "User-Agent" => "",
        }.merge(additional_headers)

        if @include_api_key && ENV["EUPAGO_API_KEY"]
          headers["Authorization"] = "ApiKey #{ENV["EUPAGO_API_KEY"]}"
        end

        headers
      end

      def parse_result(result)
        if result.headers["content-type"] == "application/json"
          response = result.parsed_response
        else
          response = result.body
        end

        case result.code
        when 200..299
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
