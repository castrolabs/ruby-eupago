module EuPago
  module Api
    module Auth
      # https://eupago.readme.io/reference/generate-bearer-token
      def self.token(body)
        result = EuPago::Client.new({ prefix_base_url: "/api" }).post("/auth/token", body: body, headers: {
          "Content-Type" => "application/x-www-form-urlencoded",
        })
        EuPago::Current.auth = result
        result
      end

      def self.ensure_valid_token
        if EuPago::Current.access_token.nil? || EuPago::Current.token_expired?
          fetch_client_credentials_token
        end
      end

      def self.fetch_client_credentials_token
        token(
          grant_type: EuPago::Constants::GRANT_TYPES[:client_credentials],
          client_id: ENV["EUPAGO_CLIENT_ID"],
          client_secret: ENV["EUPAGO_CLIENT_SECRET"],
        )
      end
    end
  end
end
