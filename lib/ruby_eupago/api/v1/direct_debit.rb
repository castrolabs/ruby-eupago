module EuPago
  module Api
    module V1
      class DirectDebit < Base
        # https://eupago.readme.io/reference/direct-debit-authorization
        def self.authorization(params)
          client.post("/v1.02/directdebit/authorization", body: params)
        end

        # https://eupago.readme.io/reference/direct-debit-payment
        def self.payment(reference, params)
          client.post("/v1.02/directdebit/payment/#{reference}", body: params)
        end
      end
    end
  end
end
