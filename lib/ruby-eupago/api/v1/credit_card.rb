module EuPago
  module Api
    module V1
      class CreditCard
        # https://eupago.readme.io/reference/credit-card-recurrence-authorization
        def self.subscription(params)
          V1.client.post("/v1.02/creditcard/subscription", body: params)
        end

        # https://eupago.readme.io/reference/credit-card-recurrence-payment
        def self.payment(recurrent_id, params)
          V1.client.post("/v1.02/creditcard/payment/#{recurrent_id}", body: params)
        end

        # https://eupago.readme.io/reference/credit-card
        def self.create(params)
          V1.client.post("/v1.02/creditcard/create", body: params)
        end
      end
    end
  end
end
