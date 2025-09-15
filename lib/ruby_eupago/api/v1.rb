module EuPago
  module Api
    module V1
      def self.client
        @client ||= EuPago::Api.client
      end
    end
  end
end

require_relative "v1/credit_card"
require_relative "v1/mbway"
require_relative "v1/direct_debit"
