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

      # This spec has not success, because the payment needs to be authorized by the client and trusted by Gateway
      # It will raise an error 400 Bad Request
      expect do
        described_class.payment(response["reference"], PaymentSpecHelper::Payment.direct_debit_attributes)
      end.to(raise_error(EuPago::BadRequestError))
    end
  end
end
