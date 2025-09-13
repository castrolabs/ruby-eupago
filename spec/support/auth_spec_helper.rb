class AuthSpecHelper
  def self.with_auth
    EuPago::Api::Auth.token({
      grant_type: EuPago::Constants::GRANT_TYPES[:client_credentials],
      client_id: ENV["EUPAGO_CLIENT_ID"],
      client_secret: ENV["EUPAGO_CLIENT_SECRET"],
    })
  end
end
