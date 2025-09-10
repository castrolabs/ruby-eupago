require "httparty"

module EuPago::Api
  class Client
    def self.get(api_url, query: {})
      result = HTTParty.get(
        api_url,
        base_uri: base_url,
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

    def self.post(api_url, body: {})
      result = HTTParty.post(
        api_url,
        base_uri: base_url,
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

    # https://eupago.readme.io/reference/api-eupago
    def self.base_url
      if ENV["EUPAGO_SANDBOX"]
        "https://sandbox.eupago.pt/api"
      else
        "https://clientes.eupago.pt/api"
      end
    end

    def self.parse_result(result)
      if result.headers["content-type"] == "application/json"
        response = result.parsed_response
      else
        response = result.body
      end

      case result.code
      when 200
        result.parsed_response
      when 401
        raise EuPagoUnauthorizedError, "[Eupago SDK] Unauthorized: #{response}"
      when 400
        raise EuPagoBadRequestError, "[Eupago SDK] Bad Request: #{response}"
      when 404
        raise EuPagoNotFoundError, "[Eupago SDK] Not Found: #{response}"
      when 403
        raise EuPagoForbiddenError, "[Eupago SDK] Forbidden: #{response}"
      else
        raise EuPagoClientError, "[Eupago SDK] Error (#{result.code}): #{response}"
      end
    end
  end

  class EuPagoClientError < StandardError; end
  class EuPagoUnauthorizedError < StandardError; end
  class EuPagoBadRequestError < StandardError; end
  class EuPagoNotFoundError < StandardError; end
  class EuPagoForbiddenError < StandardError; end
end
