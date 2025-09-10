require_relative "test_helper"

Response = Struct.new(:code, :body)

class CreditCardRecurrentTest < Minitest::Test
  def setup
    @params = { amount: 1000, currency: "EUR" }
    @recurrent_id = 1000
  end

  def test_subscription_success
    Api::Client.stubs(:post).with("/v1.02/creditcard/subscription", body: @params).returns(Response.new(200, '{"success":true}'))
    response = CreditCard::Recurrent.subscription(@params)
    assert_equal(200, response.code)
  end

  def test_subscription_failure
    Api::Client.stubs(:post).with("/v1.02/creditcard/subscription", body: @params).returns(Response.new(400, '{"error":"Bad Request"}'))
    response = CreditCard::Recurrent.subscription(@params)
    assert_equal(400, response.code)
  end

  def test_payment_success
    Api::Client.stubs(:post).with("/v1.02/creditcard/payment/#{@recurrent_id}", body: @params).returns(Response.new(200, '{"success":true}'))
    response = CreditCard::Recurrent.payment(@recurrent_id, @params)
    assert_equal(200, response.code)
  end

  def test_payment_failure
    Api::Client.stubs(:post).with("/v1.02/creditcard/payment/#{@recurrent_id}", body: @params).returns(Response.new(400, '{"error":"Bad Request"}'))
    response = CreditCard::Recurrent.payment(@recurrent_id, @params)
    assert_equal(400, response.code)
  end
end
