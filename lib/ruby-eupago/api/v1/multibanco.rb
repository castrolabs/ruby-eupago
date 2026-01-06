module EuPago
  module Api
    module V1
      class Multibanco
        # https://eupago.readme.io/reference/multibanco
        def self.create(body)
          V1.body_client.post("/clientes/rest_api/multibanco/create", body: body)
        end
      end
    end
  end
end
