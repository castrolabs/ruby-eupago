require "spec_helper"

RSpec.describe(EuPago::Api::Auth, :vcr) do
  let(:params) { { amount: 1000, currency: "EUR" } }
  let(:recurrent_id) { 1000 }

  describe "Authorization" do
    context "When Success" do
      it "Should be able to generate token", :focus do
        response = described_class.token({
          grant_type: EuPago::Constants::GRANT_TYPES[:client_credentials],
          client_id: ENV["EUPAGO_CLIENT_ID"],
          client_secret: ENV["EUPAGO_CLIENT_SECRET"],
        })

        expect(response["access_token"]).not_to(be_nil)
        expect(response["transactionStatus"]).not_to(be_nil)
        expect(response["token_type"]).to(eq("Bearer"))
        expect(response["expires_in"]).to(be_a(Integer))
      end
    end
  end
end
