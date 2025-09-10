require_relative "spec_helper"

RSpec.describe(EuPago::Client) do
  def build_client(config = {})
    EuPago::Client.new(config)
  end

  around do |example|
    prev = ENV["EUPAGO_SANDBOX"]
    begin
      ENV.delete("EUPAGO_SANDBOX")
      example.run
    ensure
      ENV["EUPAGO_SANDBOX"] = prev if prev
    end
  end

  context "base url (production)" do
    it "uses production host when EUPAGO_SANDBOX is not set" do
      client = build_client
      expect(client.instance_variable_get(:@base_url)).to(eq("https://clientes.eupago.pt/api"))
    end
  end

  context "base url (sandbox)" do
    it "uses sandbox host when EUPAGO_SANDBOX is set" do
      ENV["EUPAGO_SANDBOX"] = "1"
      client = build_client
      expect(client.instance_variable_get(:@base_url)).to(eq("https://sandbox.eupago.pt/api"))
    end
  end

  context "append_base_url option" do
    it "appends the extra path segment in production" do
      client = build_client(append_base_url: "/v1.02")
      expect(client.instance_variable_get(:@base_url)).to(eq("https://clientes.eupago.pt/api/v1.02"))
    end

    it "appends the extra path segment in sandbox" do
      ENV["EUPAGO_SANDBOX"] = "1"
      client = build_client(append_base_url: "/v1.02")
      expect(client.instance_variable_get(:@base_url)).to(eq("https://sandbox.eupago.pt/api/v1.02"))
    end
  end
end
