module EuPago
  module Api
    module V1
      class Payouts
        # Fetches payout transactions with optional parameters.
        #
        # @param params [Hash] Optional parameters for the request.
        # @option params [String] :start_date The first date to filter payouts (YYYY-MM-DD).
        # @option params [String] :end_date The final date to filter payouts (YYYY-MM-DD).
        #
        # @docs https://eupago.readme.io/reference/payouts-transactions
        def self.transactions(params = {})
          V1.oauth_client.get("/management/v1.02/payouts/transactions", query: params)
        end

        # Fetches payout transactions by transaction ID (trid).
        #
        # @param trid [String] The transaction ID to filter the request.
        #
        # @docs https://eupago.readme.io/reference/trid-information
        def self.transaction_details(trid)
          V1.oauth_client.get("/management/v1.02/payouts/transactions/#{trid}")
        end
      end
    end
  end
end
