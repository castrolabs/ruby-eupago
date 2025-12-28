require "ruby-eupago/mixins/initializer"

module EuPago
  class OAuthClient
    include EuPago::Mixins::Client

    def get(api_url, query: {}, headers: {})
      EuPago::Api::Auth.ensure_valid_token
      super(api_url, query: query, headers: headers)
    end

    def post(api_url, body: {}, headers: {})
      EuPago::Api::Auth.ensure_valid_token
      super(api_url, body: body, headers: headers)
    end

    private

    def build_headers(additional_headers = {})
      headers = super(additional_headers)

      if EuPago::Current.access_token
        headers["Authorization"] = "Bearer #{EuPago::Current.access_token}"
      end

      headers
    end
  end
end
