class ClientHelper
  def self.client
    EuPago::Api::Auth.token({
      grant_type: EuPago::Constants::GRANT_TYPES[:CLIENT_CREDENTIALS],
      client_id: ENV["EUPAGO_CLIENT_ID"],
      client_secret: ENV["EUPAGO_CLIENT_SECRET"],
    })

    EuPago::Api.client
  end
end
