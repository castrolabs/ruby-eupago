module EuPago
  module Api
    module V1
      class MBWay < Base
        # https://eupago.readme.io/reference/mbway
        def self.payment(params)
          client.post("/v1.02/mbway/create", body: params)
        end
      end
    end
  end
end
