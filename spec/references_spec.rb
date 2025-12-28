require "spec_helper"

RSpec.describe(EuPago::Api::V1::References, :vcr) do
  it "It shows pending payment", tty: true, ddev: true do
    target_amount = BigDecimal("10.60")
    payload = PaymentSpecHelper::Payment.credit_card_attributes
    payload["payment"]["amount"]["value"] = BigDecimal("10.60")

    transaction = EuPago::Api::V1::CreditCard.create(payload)
    response = described_class.list({ reference: transaction["reference"] })

    expect(response["referenceList"]).not_to(be_empty)
    row = response["referenceList"].first
    expect(row["status"]).to(eq(EuPago::Constants::REFERENCE_STATUS[:pending]))
    expect(row["entity"]).not_to(be_nil)
    expect(row["datetime"]).not_to(be_nil)
    expect(BigDecimal(row["amount"])).to(eq(target_amount))
    expect(row["identifier"]).to(eq(payload["payment"]["identifier"]))
    expect(row["reference"]).to(eq(transaction["reference"]))
  end
end
