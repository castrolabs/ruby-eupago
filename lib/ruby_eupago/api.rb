require_relative "../ruby_eupago/client"
require_relative "../ruby_eupago/constants"

module EuPago
  module Api
    class << self
      attr_accessor :client, :authentication

      def client
        @client ||= EuPago::Client.new
      end
    end
  end
end
