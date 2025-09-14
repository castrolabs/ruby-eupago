require "spec_helper"

RSpec.describe(EuPago::Api::V1::CreditCard, :vcr) do
  describe "#subscription" do
    context "when success" do
      it "creates a subscription" do
        params = SubscriptionSpecHelper.valid_attributes
        response = described_class.subscription(params)

        expect(response["transactionStatus"]).to(eq("Success"))
        expect(response["statusSubs"]).to(eq("Pending"))
        expect(response["subscriptionID"]).not_to(be_nil)
        expect(response["referenceSubs"]).not_to(be_nil)
        expect(response["redirectUrl"]).not_to(be_nil)
      end

      it "creates a subscription with auto process" do
        params = SubscriptionSpecHelper.valid_attributes({
          "payment" => {
            "subscription" => {
              "autoProcess" => 1,
              "collectionDay" => Date.today.day,
            },
          },
        })

        response = described_class.subscription(params)

        expect(response["transactionStatus"]).to(eq("Success"))
        expect(response["statusSubs"]).to(eq("Pending"))
        expect(response["subscriptionID"]).not_to(be_nil)
        expect(response["referenceSubs"]).not_to(be_nil)
        expect(response["redirectUrl"]).not_to(be_nil)
      end
    end

    context "when failure" do
      it "Missing Authorization returns 401" do
        ENV.delete("EUPAGO_API_KEY")

        expect do
          described_class.subscription(params)
        end.to(raise_error(EuPago::UnauthorizedError, /\[Eupago SDK\] Unauthorized/))
      end

      it "When payment gateway fails" do
        expect do
          described_class.subscription(SubscriptionSpecHelper.valid_attributes)
        end.to(raise_error(EuPago::ClientError, /\[Eupago SDK\] Error/))
      end
    end
  end

  describe "#payment" do
    context "when success" do
      it "processes a recurrent payment", :tty, :broken do
        params = SubscriptionSpecHelper.valid_attributes
        response = described_class.subscription(params)
        
        input("Visit >> #{subscription["redirectUrl"]} << and finish payment with fake credit card before continue... Press enter to continue")
        payment_response = described_class.subscription(response["subscriptionID"], PaymentSpecHelper.valid_attributes)
        
        # TODO: Add expectations
        binding.irb
      end
    end
  end
end
