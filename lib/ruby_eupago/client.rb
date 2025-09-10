require_relative "mixins/initializer"
require_relative "api/v1"

module EuPago
  class Client
    include EuPago::Mixins::Client
  end
end
