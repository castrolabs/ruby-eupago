require "spec_helper"

RSpec.describe(EuPago::Api::V1::DirectDebit, :vcr) do
  it "lists direct debit authorizations" do
    response = described_class.list["directDebitAuthorizationsList"]

    expect(response).to(be_a(Array))

    authorization = response.first

    expect(authorization["authorizationId"]).not_to(be_nil)
    expect(authorization["creationDate"]).not_to(be_nil)
    expect(authorization["status"]).not_to(be_nil)
    expect(authorization["reference"]).not_to(be_nil)
    expect(authorization["identifier"]).not_to(be_nil)

    expect(authorization["debtor"]).to(be_a(Hash))
    expect(authorization["debtor"]["name"]).not_to(be_nil)
    expect(authorization["debtor"]["email"]).not_to(be_nil)
    expect(authorization["debtor"]["iban"]).not_to(be_nil)
    expect(authorization["debtor"]["bic"]).not_to(be_nil)

    expect(authorization["debtor"]["address"]).to(be_a(Hash))
    expect(authorization["debtor"]["address"]["street"]).not_to(be_nil)
    expect(authorization["debtor"]["address"]["zipCode"]).not_to(be_nil)
    expect(authorization["debtor"]["address"]["locality"]).not_to(be_nil)
    expect(authorization["debtor"]["address"]["country"]).to(eq("PT"))

    expect(authorization["payment"]).to(be_a(Hash))
    expect(authorization["payment"]["amount"]).not_to(be_nil)
    expect(authorization["payment"]["type"]).not_to(be_nil)
    expect(authorization["payment"]["periodicity"]).not_to(be_nil)
    expect(authorization["payment"]["collectionDay"]).not_to(be_nil)
    expect(authorization["payment"]["date"]).not_to(be_nil)
    expect(authorization["payment"]["limitDate"]).not_to(be_nil)
  end

  it "creates a direct debit authorization" do
    response = described_class.authorization(PaymentSpecHelper::Subscription.direct_debit_attributes)

    expect(response["transactionStatus"]).to(eq("Success"))
    expect(response["reference"]).not_to(be_nil)
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
