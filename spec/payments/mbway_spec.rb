require "spec_helper"

RSpec.describe(EuPago::Api::V1::MBWay, :vcr) do
  describe "MBWay" do
    context "when success" do
      it "creates a payment" do
        response = described_class.payment(PaymentSpecHelper::Payment.mbway_attributes)

        expect(response["transactionStatus"]).to(eq("Success"))
        expect(response["transactionID"]).not_to(be_nil)
        expect(response["reference"]).not_to(be_nil)
      end

      it "check mbway payment" do
        response = described_class.payment(PaymentSpecHelper::Payment.mbway_attributes)

        if VCR.current_cassette.recording?
          input("Mark the payment as paid and press Enter to continue...")
        end

        verification = EuPago::Api::V1::References.find_by_reference(response["reference"])
        expect(verification["estado_referencia"]).to(eq(EuPago::Constants::REFERENCE_STATUS[:paid]))
      end
    end
  end
end
