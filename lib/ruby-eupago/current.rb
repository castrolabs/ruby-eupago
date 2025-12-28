module EuPago
  module Current
    @auth = {}
    @token_expires_at = nil

    def self.auth=(value)
      @auth = Hash[value.map { |(k, v)| [k.to_sym, v] }]
      @token_expires_at = Time.now + @auth[:expires_in].to_i if @auth[:expires_in]
    end

    def self.access_token
      @auth[:access_token] if @auth && !@auth.empty?
    end

    def self.token_expired?
      return true if @token_expires_at.nil?
      Time.now >= @token_expires_at
    end

    def self.logged_in?
      !access_token.nil? && !access_token.empty? && !token_expired?
    end
  end
end
