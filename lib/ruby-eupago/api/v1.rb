module EuPago
  module Api
    module V1
      def self.client
        @client ||= EuPago::Api.client
      end

      def self.oauth_client
        @oauth_client ||= EuPago::Api.oauth_client
      end
    end
  end
end

require "ruby-eupago/api/v1/credit_card"
require "ruby-eupago/api/v1/mbway"
require "ruby-eupago/api/v1/direct_debit"
require "ruby-eupago/api/v1/payouts"
require "ruby-eupago/api/v1/references"
