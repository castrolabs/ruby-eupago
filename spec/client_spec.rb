require_relative "spec_helper"

RSpec.describe(EuPago::Client) do
  def build_client(config = {})
    EuPago::Client.new(config)
  end

  context "base url (production)" do
    it "uses production host when EUPAGO_SANDBOX is not set" do
      ENV["EUPAGO_PRODUCTION"] = "1"
      client = build_client
      expect(client.instance_variable_get(:@base_url)).to(eq("https://clientes.eupago.pt/api"))
    end
  end

  context "base url (sandbox)" do
    it "uses sandbox host when EUPAGO_SANDBOX is set" do
      ENV["EUPAGO_PRODUCTION"] = ""
      client = build_client
      expect(client.instance_variable_get(:@base_url)).to(eq("https://sandbox.eupago.pt/api"))
    end
  end
end
