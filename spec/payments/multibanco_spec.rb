require "spec_helper"

RSpec.describe(EuPago::Api::V1::Multibanco, :vcr) do
  describe "Multibanco" do
    context "when success" do
      it "creates a authorization payment" do
        response = described_class.create(PaymentSpecHelper::Payment.multibanco_attributes)

        expect(response["sucesso"]).to(eq(true))
        expect(response["referencia"]).not_to(be_nil)
        expect(response["entidade"]).not_to(be_nil)
        # valor -> request float -> response string
        # 10.00000
        expect(response["valor"]).to(eq(format("%.5f", 10)))
        expect(response["data_inicio"]).to(eq(Date.today.strftime("%Y-%m-%d")))
        expect(response["data_fim"]).to(eq((Date.today + 7).strftime("%Y-%m-%d")))
        expect(response["valor_minimo"]).to(eq("10"))
        expect(response["valor_maximo"]).to(eq("10"))
        expect(response["estado"]).to(eq(0)) # ?
      end

      it "verify payment", tty: true do
        response = described_class.create(PaymentSpecHelper::Payment.multibanco_attributes)

        # Only as for tty mode and when recording a new cassette
        if VCR.current_cassette.recording?
          input("Make the payment using the generated reference #{response["referencia"]} and entidade #{response["entidade"]}")
        end

        verification = EuPago::Api::V1::References.find_by_reference(response["referencia"])
        expect(verification["estado_referencia"]).to(eq(EuPago::Constants::REFERENCE_STATUS[:paid]))
      end
    end
  end
end
