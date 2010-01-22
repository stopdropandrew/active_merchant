require 'test_helper'

class ZongNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @zong = Zong::Notification.new(http_raw_data(post_data))
  end

  def test_accessors
    assert @zong.complete?
    assert_equal "COMPLETED", @zong.status
    assert_equal "1234", @zong.transaction_ref
    assert_equal "3.9900_USD", @zong.item_ref
    assert_equal "", @zong.failure
    assert_equal "MOBILE", @zong.payment_method
    assert_equal "+11234567890", @zong.msisdn
    assert_equal "1.9700 USD", @zong.out_payment
    assert @zong.test?
  end

  def test_failure_response
    @zong.stubs(:valid_signature?).returns(false)
    assert_equal 'INVALID', @zong.response
  end
  
  def test_success_response
    @zong.stubs(:valid_signature?).returns(true)
    assert_equal '1234:OK', @zong.response
  end

  def test_respond_to_acknowledge
    assert @zong.respond_to?(:acknowledge)
  end

  private
  def post_data
    data = {
      "transactionRef" => "1234",
      "itemRef" => "3.9900_USD",
      "status" => "COMPLETED", 
      "failure" => "", 
      "method" => "MOBILE", 
      "msisdn" => "+11234567890", 
      "outPayment" => "1.9700 USD", 
      "signatureVersion" => 1,
      "simulated" => "", 
      "simulated" => "true"
    }
  end
  
  def http_raw_data(params)
    params.map{|key, value| "#{key}=#{CGI.escape(value.to_s)}"}.join("&")
  end
    
end
