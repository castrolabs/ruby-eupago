require "spec_helper"

RSpec.describe(EuPago::Api::V1::MBWay, :vcr) do
  describe "MBWay" do
    context "when success" do
      it "creates a subscription" do
        response = described_class.payment(PaymentSpecHelper::Payment.mbway_attributes)

        expect(response["transactionStatus"]).to(eq("Success"))
        expect(response["transactionID"]).not_to(be_nil)
        expect(response["reference"]).not_to(be_nil)
      end
    end
  end
end
