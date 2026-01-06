module EuPago
  module Api
    module V1
      class Pix
        # TODO: Create spec when support enable pix payments in my sandbox account
        # https://eupago.readme.io/reference/europix
        def self.payment(body)
          V1.client.post("/pix/create", body: body)
        end
      end
    end
  end
end
