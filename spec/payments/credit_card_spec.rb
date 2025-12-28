require "spec_helper"

RSpec.describe(EuPago::Api::V1::CreditCard, :vcr) do
  describe "#subscription" do
    context "when success" do
      it "creates a subscription" do
        response = described_class.subscription(PaymentSpecHelper::Subscription.credit_card_attributes)

        expect(response["transactionStatus"]).to(eq("Success"))
        expect(response["statusSubs"]).to(eq("Pending"))
        expect(response["subscriptionID"]).not_to(be_nil)
        expect(response["referenceSubs"]).not_to(be_nil)
        expect(response["redirectUrl"]).not_to(be_nil)
      end

      it "creates a subscription with auto process" do
        params = PaymentSpecHelper::Subscription.credit_card_attributes({
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
      it "When payment gateway fails" do
        expect do
          described_class.subscription(PaymentSpecHelper::Subscription.credit_card_attributes)
        end.to(raise_error(EuPago::ClientError, /\[Eupago SDK\] Error/))
      end
    end

    context "Authorization" do
      before do
        @original_api_key = ENV["EUPAGO_API_KEY"]
        ENV.delete("EUPAGO_API_KEY")
      end

      after do
        ENV["EUPAGO_API_KEY"] = @original_api_key
      end

      it "Missing Authorization returns 401" do
        expect do
          described_class.subscription(PaymentSpecHelper::Subscription.credit_card_attributes)
        end.to(raise_error(EuPago::UnauthorizedError, /\[Eupago SDK\] Unauthorized/))
      end
    end
  end

  describe "#payment" do
    context "when success" do
      it "processes a recurrent payment", :tty do
        params = PaymentSpecHelper::Subscription.credit_card_attributes
        response = described_class.subscription(params)

        # Only as for tty mode and when recording a new cassette
        if VCR.current_cassette.recording?
          # https://eupago.readme.io/reference/test-cards
          input("Visit >> #{response["redirectUrl"]} << and finish payment with fake credit card before continue... Press enter to continue")
        end

        payment_response = described_class.payment(response["subscriptionID"], PaymentSpecHelper::Subscription.credit_card_attributes)

        expect(payment_response["transactionStatus"]).to(eq("Success"))
        expect(payment_response["status"]).to(eq("Paid"))
        expect(payment_response["transactionID"]).not_to(be_nil)
        expect(payment_response["reference"]).not_to(be_nil)
        expect(payment_response["message"]).to(eq("Payment has been executed successfully."))
      end

      it "Process a one time credit card payment", tty: true, focus: true do
        response = described_class.create(PaymentSpecHelper::Payment.credit_card_attributes)

        expect(response["redirectUrl"]).not_to(be_nil)
        if VCR.current_cassette.recording?
          # https://eupago.readme.io/reference/test-cards
          input("Visit >> #{response["redirectUrl"]} << and finish payment with fake credit card before continue... Press enter to continue")
        end

        expect(response["transactionStatus"]).to(eq("Success"))
        expect(response["transactionID"]).not_to(be_nil)
        expect(response["reference"]).not_to(be_nil)

        expect(PaymentSpecHelper.is_paid_status?(response)).to(be(true))
      end

      it "get staus without paying a one time credit card payment" do
        response = described_class.create(PaymentSpecHelper::Payment.credit_card_attributes)

        expect(response["transactionStatus"]).to(eq("Success"))
        expect(response["redirectUrl"]).not_to(be_nil)
        expect(response["transactionID"]).not_to(be_nil)
        expect(response["reference"]).not_to(be_nil)
        expect(PaymentSpecHelper.is_pending_status?(response)).to(be(true))
      end
    end

    context "when failure" do
      it "process the payment without finish OTP", :tty do
        PaymentSpecHelper::Subscription.credit_card_attributes
        response = described_class.subscription(PaymentSpecHelper::Subscription.credit_card_attributes)

        # Only as for tty mode and when recording a new cassette
        if VCR.current_cassette.recording?
          # https://eupago.readme.io/reference/test-cards
          input("Visit >> #{response["redirectUrl"]} << and finish payment with fake credit card before continue... Press enter to continue")
        end

        expect do
          described_class.payment(response["subscriptionID"], PaymentSpecHelper::Subscription.credit_card_attributes)
        end.to(raise_error(EuPago::BadRequestError, /\[Eupago SDK\] Bad Request/))
      end

      it "process the payment after OTP fails", :tty do
        PaymentSpecHelper::Subscription.credit_card_attributes
        response = described_class.subscription(PaymentSpecHelper::Subscription.credit_card_attributes)

        # Only as for tty mode and when recording a new cassette
        if VCR.current_cassette.recording?
          # https://eupago.readme.io/reference/test-cards
          input("Visit >> #{response["redirectUrl"]} << and finish payment with fake credit card before continue... Press enter to continue")
        end

        expect do
          described_class.payment(response["subscriptionID"], PaymentSpecHelper::Payment.credit_card_missing_url_attributes)
        end.to(raise_error(EuPago::BadRequestError, /\[Eupago SDK\] Bad Request/))
      end
    end
  end
end
