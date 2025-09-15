require_relative "mixins/initializer"

module EuPago
  class Client
    include EuPago::Mixins::Client
  end
end
