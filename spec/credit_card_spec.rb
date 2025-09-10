require_relative "spec_helper"

Response = Struct.new(:code, :body)

RSpec.describe EuPago::CreditCard::Recurrent do
  let(:params) { { amount: 1000, currency: "EUR" } }
  let(:recurrent_id) { 1000 }

  describe ".subscription" do
    context "when successful" do
      it "returns 200 code", focus: true do
        allow(EuPago::Api::Client).to receive(:post)
          .with("/v1.02/creditcard/subscription", body: params)
          .and_return(Response.new(200, '{"success":true}'))

        response = described_class.subscription(params)
        expect(response.code).to eq(200)
      end
    end

    context "when failure" do
      it "Missing Authorization returns 403 code and html", focus: true do
        allow(EuPago::Api::Client).to receive(:post)
          .with("/v1.02/creditcard/subscription", body: params)
          .and_raise(EuPago::Api::EuPagoForbiddenError, '[Eupago SDK] Forbidden: <html>...</html>')

        expect {
          described_class.subscription(params)
        }.to raise_error(EuPago::Api::EuPagoForbiddenError, /\[Eupago SDK] Forbidden/)
      end
    end
  end

  describe ".payment" do
    context "when successful" do
      it "returns 200 code" do
        allow(EuPago::Api::Client).to receive(:post)
          .with("/v1.02/creditcard/payment/#{recurrent_id}", body: params)
          .and_return(Response.new(200, '{"success":true}'))

        response = described_class.payment(recurrent_id, params)
        expect(response.code).to eq(200)
      end
    end

    context "when failure" do
      it "returns 400 code" do
        allow(EuPago::Api::Client).to receive(:post)
          .with("/v1.02/creditcard/payment/#{recurrent_id}", body: params)
          .and_return(Response.new(400, '{"error":"Bad Request"}'))

        response = described_class.payment(recurrent_id, params)
        expect(response.code).to eq(400)
      end
    end
  end
end
