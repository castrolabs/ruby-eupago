require_relative "utils"

module PaymentSpecHelper
  class Subscription
    def self.credit_card_attributes(overrides = {})
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
              "email" => Utils.customer_email,
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

    def self.direct_debit_attributes(overrides = {})
      {
        "debtor" => {
          "address" => {
            "zipCode" => "1234-5678",
            "country" => "PT",
            "street" => "Rua das coisas",
            "locality" => "Lisboa",
          },
          "iban" => "PT50123443211234567890172", # Fake IBAN for tests given by Eupago Docs
          "name" => "NomeDoDevedor",
          "bic" => "CGDIPTPL",
          "email" => Utils.customer_email,
        },
        "payment" => {
          "autoProcess" => "0",
          "type" => EuPago::Constants::PAYMENT_TYPES[:recurring],
          "date" => Date.today.strftime("%Y-%m-%d"),
          "amount" => 20,
          "collectionDay" => nil,
          "periodicity" => EuPago::Constants::RECURRENT_PAYMENT_INTERVALS[:monthly],
          "limitDate" => (Date.today >> 12).strftime("%Y-%m-%d"),
        },
        "adminCallback" => nil,
        "identifier" => "Test Direct Debit Subscription",
      }
    end
  end

  class Payment
    def self.credit_card_attributes(overrides = {})
      base_attributes = {
        "payment" => {
          "identifier" => "Test One time credit card payment",
          "amount" => {
            "currency" => "EUR",
            "value" => 10,
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

    def self.credit_card_missing_url_attributes(overrides = {})
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

    def self.mbway_attributes(overrides = {})
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

    def self.direct_debit_attributes(overrides = {})
      base_attributes = {
        "type" => "RCUR",
        "date" => (Date.today + 5).strftime("%Y-%m-%d"),
        "amount" => 10,
        "obs" => "Test Direct Debit Payment",
      }

      Utils.deep_merge(base_attributes, overrides)
    end
  end

  EuPago::Constants::REFERENCE_STATUS.each_key do |status_key|
    define_singleton_method("is_#{status_key}_status?") do |response|
      transaction = EuPago::Api::V1::References.list({ reference: response["reference"] })
      return false if transaction["referenceList"].empty?

      row = transaction["referenceList"].first
      row["status"] == EuPago::Constants::REFERENCE_STATUS[status_key]
    end
  end
end
