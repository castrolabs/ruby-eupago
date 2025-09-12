require_relative "../ruby_eupago/client"

module EuPago
  module Api
    class << self
      attr_accessor :authentication

      def client
        @client ||= EuPago::Client.new
      end
    end
  end
end
