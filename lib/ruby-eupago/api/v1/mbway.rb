module EuPago
  module Api
    module V1
      class MBWay
        # https://eupago.readme.io/reference/mbway
        def self.payment(body)
          V1.client.post("/v1.02/mbway/create", body: body)
        end
      end
    end
  end
end
