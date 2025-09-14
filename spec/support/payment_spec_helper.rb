require_relative "utils"

class PaymentSpecHelper
  def self.valid_attributes(overrides = {})
    base_attributes = {
      "payment" => {
        "identifier" => "Test Payment",
        "amount" => {
          "currency" => "EUR",
          "value" => 10,
        },
        "customer" => {
          "notify" => true,
        },
      },
    }

    Utils.deep_merge(base_attributes, overrides)
  end
end
