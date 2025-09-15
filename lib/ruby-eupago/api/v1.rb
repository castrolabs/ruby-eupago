module EuPago
  module Api
    module V1
      def self.client
        @client ||= EuPago::Api.client
      end
    end
  end
end

require "ruby-eupago/api/v1/credit_card"
require "ruby-eupago/api/v1/mbway"
require "ruby-eupago/api/v1/direct_debit"
