require_relative "spec_helper"

RSpec.describe(EuPago::Api::V1::CreditCard, :vcr) do
  let(:params) { { amount: 1000, currency: "EUR" } }
  let(:recurrent_id) { 1000 }
  let(:client) { EuPago::Api::V1::CreditCard }

  describe "#subscription" do
    context "when failure" do
      it "Missing Authorization returns 403 code and html", :vcr, :focus do
        expect do
          client.subscription(params)
        end.to(raise_error(EuPago::EuPagoForbiddenError, /\[Eupago SDK] Forbidden/))
      end
    end
  end
end
