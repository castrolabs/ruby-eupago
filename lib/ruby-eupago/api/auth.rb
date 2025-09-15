module EuPago
  module Api
    module Auth
      # https://eupago.readme.io/reference/generate-bearer-token
      def self.token(body)
        result = EuPago::Client.new.post("/auth/token", body: body, headers: {
          "Content-Type" => "application/x-www-form-urlencoded",
        })
        EuPago::Current.auth = result
        result
      end
    end
  end
end
