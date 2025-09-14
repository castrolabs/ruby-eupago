require_relative "utils"

class SubscriptionSpecHelper
  def self.valid_attributes(overrides = {})
    base_attributes = {
      "payment" => {
        "identifier" => "Test Subscription",
        "amount" => {
          "currency" => "EUR",
          "value" => 10,
        },
        "subscription" => {
          "autoProcess" => 0,
          "collectionDay" => nil,
          "periodicity" => EuPago::Constants::RECURRENT_PAYMENT_INTERVALS[:monthly],
          "date" => Date.today.strftime("%Y-%m-%d"),
          "limitDate" => (Date.today >> 12).strftime("%Y-%m-%d"),
          "customer" => {
            "notify" => true,
            "email" => "alexoliveira7x+eupagotester@gmail.com",
            "phone" => nil,
            "name" => "Test User",
          },
        },
        "successUrl" => "https://www.test.com/success",
        "failUrl" => "https://www.test.com/fail",
        "backUrl" => "https://www.test.com/back",
        "lang" => "PT",
        "minutesFormUp" => 1440,
      },
    }

    Utils.deep_merge(base_attributes, overrides)
  end
end
