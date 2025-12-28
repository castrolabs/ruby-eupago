module EuPago
  module Api
    module V1
      class DirectDebit
        # https://eupago.readme.io/reference/direct-debit-authorization
        def self.authorization(body)
          V1.client.post("/directdebit/authorization", body: body)
        end

        # https://eupago.readme.io/reference/direct-debit-payment
        def self.payment(reference, body)
          V1.client.post("/directdebit/payment/#{reference}", body: body)
        end
      end
    end
  end
end
