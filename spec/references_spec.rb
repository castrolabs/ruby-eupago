require "spec_helper"

RSpec.describe(EuPago::Api::V1::References, :vcr) do
  it "It shows pending payment", tty: true do
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

  it "find_by_reference returns reference information", tty: true do
    payload = PaymentSpecHelper::Payment.credit_card_attributes
    transaction = EuPago::Api::V1::CreditCard.create(payload)
    
    # Only as for tty mode and when recording a new cassette
    if VCR.current_cassette.recording?
      # https://eupago.readme.io/reference/test-cards
      input("Visit >> #{transaction["redirectUrl"]} << and finish payment with fake credit card before continue... Press enter to continue")
    end

    response = described_class.find_by_reference(transaction["reference"])
    expect(response["referencia"]).not_to(be_nil)
    expect(response["identificador"]).not_to(be_nil)
    expect(response["estado"]).not_to(be_nil)
    expect(response["data_criacao"]).not_to(be_nil)
    expect(response["hora_criacao"]).not_to(be_nil)
    expect(response["estado_referencia"]).not_to(be_nil)
    expect(response["sucesso"]).to(be(true))
    expect(response["resposta"]).not_to(be_nil)

    # Payment details
    expect(response["pagamentos"]).to(be_an(Array))
    payment = response["pagamentos"].first
    expect(payment["estado"]).to(eq(EuPago::Constants::REFERENCE_STATUS[:paid]))
    expect(payment["trid"]).not_to(be_nil)
    expect(payment["valor"]).not_to(be_nil)
    expect(payment["comissao"]).not_to(be_nil)
    expect(payment["arquivada"]).not_to(be_nil)
    expect(payment["data_pagamento"]).not_to(be_nil)
    expect(payment["hora_pagamento"]).not_to(be_nil)
    expect(payment["data_previsao_transferencia"]).not_to(be_nil)
  end
  
  it "find_by_reference does not return payment if pending" do
    payload = PaymentSpecHelper::Payment.credit_card_attributes
    transaction = EuPago::Api::V1::CreditCard.create(payload)
    response = described_class.find_by_reference(transaction["reference"])

    expect(response["referencia"]).not_to(be_nil)
    expect(response["identificador"]).not_to(be_nil)
    expect(response["estado"]).not_to(be_nil)
    expect(response["data_criacao"]).not_to(be_nil)
    expect(response["hora_criacao"]).not_to(be_nil)
    expect(response["estado_referencia"]).not_to(be_nil)
    expect(response["sucesso"]).to(be(true))
    expect(response["resposta"]).not_to(be_nil)
    
    # Payment details
    expect(response["pagamentos"]).to(be(nil))
  end
end
