require "spec_helper"

RSpec.describe(EuPago::Api::V1::DirectDebit, :vcr) do
  describe "#payment" do
    context "when success" do
      it "creates a direct debit authorization" do
        response = described_class.authorization(PaymentSpecHelper::Subscription.direct_debit_attributes)

        expect(response["transactionStatus"]).to(eq("Success"))
        expect(response["reference"]).not_to(be_nil)
      end
    end

    it "raises an error when attempting payment without prior authorization" do
      response = described_class.authorization(PaymentSpecHelper::Subscription.direct_debit_attributes)

      # This spec fails because the payment requires prior client authorization and gateway approval.
      # Attempting payment without these steps results in a 400 Bad Request error.
      expect do
        described_class.payment(response["reference"], PaymentSpecHelper::Payment.direct_debit_attributes)
      end.to(raise_error(EuPago::BadRequestError))
    end
  end
end
