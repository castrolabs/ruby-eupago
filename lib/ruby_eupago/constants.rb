# frozen_string_literal: true

module EuPago
  module Constants
    GRANT_TYPES = {
        CLIENT_CREDENTIALS: "client_credentials",
        REFRESH: "refresh_token",
        PASSWORD: "password"
    }.freeze
  end
end
