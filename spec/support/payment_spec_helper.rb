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

  def self.mbway_valid_attributes(overrides = {})
    base_attributes = {
      "payment" => {
        "identifier" => "Test MBWay Payment",
        "amount" => {
          "currency" => "EUR",
          "value" => 10,
        },
        "customerPhone" => "912345678", # Fake number for tests
        "countryCode" => "+351",
        "customer" => {
          "notify" => true,
          "name" => "Test User",
          "email" => Utils.customer_email,
          # Field: failOver
          # A parameter that defines if the final client will recieve an sms/email
          # reminder notification in case of fail payment ("0" or "1" string value)
          "failOver" => "0",
          # Field: phone
          # required if failOver = "1"
          # 9 digits string
          "phone" => "912345678",
        },
      },
    }

    Utils.deep_merge(base_attributes, overrides)
  end
end
