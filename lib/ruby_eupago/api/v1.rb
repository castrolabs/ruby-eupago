require_relative "../../ruby_eupago/client"
require_relative "../../ruby_eupago/mixins/initializer"

module EuPago
  module Api
    module V1
      class << self
        def client
          @client ||= EuPago::Client.new({ prepend_base_url: "/v1.02" })
        end
      end

      class Base
        class << self
          def client
            EuPago::Api::V1.client
          end
        end
      end
    end
  end
end

require_relative "v1/credit_card"