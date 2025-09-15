module EuPago
  module Api
    module V1
      class DirectDebit
        # https://eupago.readme.io/reference/direct-debit-authorization
        def self.authorization(params)
          V1.client.post("/v1.02/directdebit/authorization", body: params)
        end

        # https://eupago.readme.io/reference/direct-debit-payment
        def self.payment(reference, params)
          V1.client.post("/v1.02/directdebit/payment/#{reference}", body: params)
        end
      end
    end
  end
end
