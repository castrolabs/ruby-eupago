module EuPago
  module Api
    module V1
      class CreditCard
        # https://eupago.readme.io/reference/credit-card-recurrence-authorization
        def self.subscription(body)
          V1.client.post("/v1.02/creditcard/subscription", body: body)
        end

        # https://eupago.readme.io/reference/credit-card-recurrence-payment
        def self.payment(recurrent_id, body)
          V1.client.post("/v1.02/creditcard/payment/#{recurrent_id}", body: body)
        end

        # https://eupago.readme.io/reference/credit-card
        def self.create(body)
          V1.client.post("/v1.02/creditcard/create", body: body)
        end
      end
    end
  end
end
