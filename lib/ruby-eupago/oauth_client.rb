require "ruby-eupago/mixins/initializer"

module EuPago
  class OAuthClient
    include EuPago::Mixins::Client

    def initialize(config = {})
      super(config)
      @access_token = nil
      @token_expires_at = nil
    end

    def get(api_url, query: {}, headers: {})
      ensure_valid_token
      super(api_url, query: query, headers: headers)
    end

    def post(api_url, body: {}, headers: {})
      ensure_valid_token
      super(api_url, body: body, headers: headers)
    end

    private

    def ensure_valid_token
      if @access_token.nil? || token_expired?
        fetch_token
      end
    end

    def token_expired?
      return true if @token_expires_at.nil?
      Time.now >= @token_expires_at
    end

    def fetch_token
      auth_client = EuPago::Client.new
      result = auth_client.post("/auth/token",
        body: {
          grant_type: EuPago::Constants::GRANT_TYPES[:client_credentials],
          client_id: ENV["EUPAGO_CLIENT_ID"],
          client_secret: ENV["EUPAGO_CLIENT_SECRET"],
        },
        headers: {
          "Content-Type" => "application/x-www-form-urlencoded",
        }
      )

      @access_token = result["access_token"]
      @token_expires_at = Time.now + result["expires_in"].to_i
    end

    def build_headers(additional_headers = {})
      headers = super(additional_headers)

      if @access_token
        headers["Authorization"] = "Bearer #{@access_token}"
      end

      headers
    end
  end
end
