module EuPago
  module Current
    @auth = {}

    def self.auth=(value)
      @auth = Hash[value.map { |(k, v)| [k.to_sym, v] }]
    end

    def self.access_token
      @auth[:access_token] if @auth && !@auth.empty?
    end

    def self.logged_in?
      !access_token.nil? && !access_token.empty?
    end
  end
end
