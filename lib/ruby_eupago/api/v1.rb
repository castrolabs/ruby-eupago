module EuPago
  module Api
    module V1
      def self.client
        @client ||= EuPago::Api.client
      end
    end
  end
end

require "ruby_eupago/api/v1/credit_card"
require "ruby_eupago/api/v1/mbway"
require "ruby_eupago/api/v1/direct_debit"
