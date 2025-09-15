module EuPago
  module Api
    def self.client
      @client ||= EuPago::Client.new({ include_api_key: true })
    end
  end
end
