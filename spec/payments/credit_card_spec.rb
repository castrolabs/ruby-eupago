require "spec_helper"

RSpec.describe(EuPago::Api::V1::CreditCard, :vcr) do
  let(:params) do
    {
      "payment" => {
        "identifier" => "Test Subscription",
        "amount" => {
          "currency" => "EUR",
          "value" => 10,
        },
        "subscription" => {
          "autoProcess" => 0,
          "collectionDay" => nil,
          "periodicity" => EuPago::Constants::RECURRENT_PAYMENT_INTERVALS[:monthly],
          "date" => Date.today.strftime("%Y-%m-%d"),
          "limitDate" => (Date.today >> 12).strftime("%Y-%m-%d"),
          "customer" => {
            "notify" => true,
            "email" => "alexoliveira7x+eupagotester@gmail.com",
            "phone" => nil,
            "name" => "Test User",
          },
        },
        "successUrl" => "https://www.test.com/success",
        "failUrl" => "https://www.test.com/fail",
        "backUrl" => "https://www.test.com/back",
        "lang" => "PT",
        "minutesFormUp" => 1440,
      },
    }
  end
  let(:recurrent_id) { 1000 }

  describe "#subscription" do
    context "when success" do
      it "creates a subscription" do
        response = described_class.subscription(params)

        expect(response["transactionStatus"]).to(eq("Success"))
        expect(response["statusSubs"]).to(eq("Pending"))
        expect(response["subscriptionID"]).not_to(be_nil)
        expect(response["referenceSubs"]).not_to(be_nil)
        expect(response["redirectUrl"]).not_to(be_nil)
      end

      it "creates a subscription with auto process" do
        params["payment"]["subscription"]["autoProcess"] = 1
        params["payment"]["subscription"]["collectionDay"] = Date.today.day

        response = described_class.subscription(params)

        expect(response["transactionStatus"]).to(eq("Success"))
        expect(response["statusSubs"]).to(eq("Pending"))
        expect(response["subscriptionID"]).not_to(be_nil)
        expect(response["referenceSubs"]).not_to(be_nil)
        expect(response["redirectUrl"]).not_to(be_nil)
      end
    end
    context "when failure" do
      before(:each) do
        # Remove env variables to simulate missing auth
        ENV.delete("EUPAGO_API_KEY")
      end

      it "Missing Authorization returns 401" do
        expect do
          described_class.subscription(params)
        end.to(raise_error(EuPago::UnauthorizedError, /\[Eupago SDK\] Unauthorized/))
      end
    end
  end
end
