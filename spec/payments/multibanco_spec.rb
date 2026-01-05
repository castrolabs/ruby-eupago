require "spec_helper"

RSpec.describe(EuPago::Api::V1::Multibanco, :vcr) do
  describe "Multibanco" do
    context "when success" do
      it "creates a subscription" do
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
    end
  end
end
