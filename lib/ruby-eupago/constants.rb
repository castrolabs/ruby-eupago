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
    }.freeze

    REFERENCE_STATUS = {
      paid: "paga",
      pending: "pendente",
      expired: "expirada",
      error: "erro",
      canceled: "cancelada",
      refunded: "reembolsada",
      returned: "devolvida",
      archived: "arquivada",
    }.freeze
  end
end
