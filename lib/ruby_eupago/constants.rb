module EuPago
  module Constants
    GRANT_TYPES = {
      client_credentials: "client_credentials",
      refresh: "refresh_token",
      password: "password",
    }.freeze

    RECURRENT_PAYMENT_INTERVALS = {
      weekly: "Semanal",
      biweekly: "Quinzenal",
      monthly: "Mensal",
      trimesterly: "Trimestral",
      semiannual: "Semestral",
      annual: "Anual",
    }.freeze

    PAYMENT_TYPES = {
      once: "OOFF",
      recurring: "RCUR",
      final: "FNAL",
    }
  end
end
