require_relative "../api"

module EuPago
  module Api
    module Auth
      class << self
        def client
          EuPago::Api.client
        end

        # https://eupago.readme.io/reference/generate-bearer-token
        def token(body)
          result = client.post("/auth/token", body: body, headers: { "Content-Type" => "application/x-www-form-urlencoded" })
          EuPago::Api.authentication = result

          result
        end
      end
    end
  end
end
