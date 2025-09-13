require_relative "../ruby_eupago/client"

module EuPago
  module Api
    @auth = {}

    def self.client
      @client ||= EuPago::Client.new({ include_api_key: true })
    end

    def self.access_token
      @auth[:access_token] if @auth && !@auth.empty?
    end

    def self.auth
      @auth
    end

    def self.auth=(value)
      @auth = Hash[value.map { |(k, v)| [k.to_sym, v] }]
    end

    def self.logged_in?
      !access_token.nil? && !access_token.empty?
    end
  end
end
