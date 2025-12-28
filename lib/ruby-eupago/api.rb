module EuPago
  module Api
    
    # EuPago current REST API uses three different types of authentication:
    #
    # 1 - ApiKey Auth (API Key sent as an header param)
    def self.client
      @client ||= EuPago::Client.new({ include_api_key: true, prefix_base_url: '/api/v1.02' })
    end
    
    # 2 -OAuth 2.0 (Bearer Token sent as an header param)
    def self.oauth_client
      @oauth_client ||= EuPago::OAuthClient.new({ prefix_base_url: '/api' })
    end
    
    # 3 - API Key sent as a body param
    def self.body_client
      @body_client ||= EuPago::Client.new({ include_api_key: false, include_api_key_in_body: true })
    end
  end
end
