module EuPago
  module Api
    def self.client
      @client ||= EuPago::Client.new({ include_api_key: true })
    end

    def self.oauth_client
      @oauth_client ||= EuPago::OAuthClient.new
    end
  end
end
