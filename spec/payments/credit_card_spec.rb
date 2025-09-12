require "spec_helper"

RSpec.describe(EuPago::Api::V1::CreditCard, :vcr, :focus) do
  let(:params) { { amount: 1000, currency: "EUR" } }
  let(:recurrent_id) { 1000 }

  describe "#subscription" do
    context "when failure" do
      it "Missing Authorization returns 401", :vcr do
        expect do
          described_class.subscription(params)
        end.to(raise_error(EuPago::UnauthorizedError, /\[Eupago SDK] Unauthorized/))
      end
    end
  end
end
