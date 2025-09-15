module EuPago
  module Api
    module V1
      class MBWay
        # https://eupago.readme.io/reference/mbway
        def self.payment(params)
          V1.client.post("/v1.02/mbway/create", body: params)
        end
      end
    end
  end
end
