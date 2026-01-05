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
        "adminCallback" => "https://testlekito.free.beeceptor.com?source=RubyEupagoTests",
        "identifier" => "Test Direct Debit Subscription",
      }
    end

    def self.direct_debit_payment_attributes(overrides = {})
      {
        date: direct_debit_collection_date,
        amount: 20,
        obs: "Test Direct Debit Payment - payment after authorization",
        type: EuPago::Constants::PAYMENT_TYPES[:recurring],
      }
    end

    def self.direct_debit_collection_date
      # 5 business days from today
      date = Date.today
      days_added = 0
      while days_added < 5
        date += 1
        days_added += 1 unless date.saturday? || date.sunday?
      end

      date.strftime("%Y-%m-%d")
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

    def self.multibanco_attributes(overrides = {})
      {
        "identifier" => "Test Multibanco Payment",
        "data_inicio" => Date.today.strftime("%Y-%m-%d"),
        "data_fim" => (Date.today + 7).strftime("%Y-%m-%d"),
        "valor" => 10,
        # valor_maximo and valor_minimo => Maximum amount (only for references that allow payments in an interval of amounts)
        "valor_minimo" => nil,
        "valor_maximo" => nil,
        # per_dup => Defines if the reference allows 1 payment or more that 1 payment (1 = allows multiple payments | 0 = allows only 1 payment)
        "per_dup" => 0,
        "campos_extra" => [],
        "failOver" => "0",
        "email" => Utils.customer_email,
        # contacto => User phone number to receive the reminder notification (Only if failover = 1).
        "contacto" => nil,
        "userID" => nil,
      }
    end
  end

  EuPago::Constants::REFERENCE_STATUS.each_key do |status_key|
    define_singleton_method("is_#{status_key}_status?") do |response|
      transaction = EuPago::Api::V1::References.find_by_reference(response["reference"])
      transaction["estado_referencia"] == EuPago::Constants::REFERENCE_STATUS[status_key]
    end
  end
end
