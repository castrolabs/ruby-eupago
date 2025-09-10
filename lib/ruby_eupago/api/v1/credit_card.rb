module EuPago
  module Api
    module V1
      class CreditCard < Base
        # https://eupago.readme.io/reference/credit-card-recurrence-authorization
        def self.subscription(params)
          client.post("/creditcard/subscription", body: params)
        end

        # https://eupago.readme.io/reference/credit-card-recurrence-payment
        def self.payment(recurrent_id, params)
          client.post("/creditcard/payment/#{recurrent_id}", body: params)
        end
      end
    end
  end
end
