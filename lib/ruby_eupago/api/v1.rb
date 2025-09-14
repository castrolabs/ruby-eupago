require_relative "../../ruby_eupago/client"
require_relative "../../ruby_eupago/mixins/initializer"

module EuPago
  module Api
    module V1
      class Base
        def self.client
          EuPago::Api.client
        end
      end
    end
  end
end

require_relative "v1/credit_card"
require_relative "v1/mbway"
require_relative "v1/direct_debit"
