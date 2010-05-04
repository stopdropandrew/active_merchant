require 'test_helper'

class PaysafeTest < Test::Unit::TestCase
  def setup
    @gateway = PaysafeGateway.new(fixtures(:paysafe))

    @options = { 
      :currency => 'EUR',
      :transaction_id => 'cool-trans',
      :amount => 10,
      :ok_url => 'http://www.kongregate.com/paysafe?ok=true',
      :nok_url => 'http://www.kongregate.com/paysafe?ok=false'
    }
  end
  
  def test_successful_authorize
    @gateway.expects(:ssl_post).returns(successful_authorize_response)
    
    assert response = @gateway.authorize(@options)
    assert_instance_of Response, response
    assert_success response
  end
  
  # def test_successful_authorize
  #   @gateway.expects(:ssl_post).returns(successful_authorize_response)
  #   
  #   assert response = @gateway.authorize(@authorize_options)
  #   assert_instance_of Response, response
  #   assert_success response
  #   
  #   # Replace with authorization number from the successful response
  #   assert_equal 'BMhFnN4SohBrWODtHZn62GTAx3tm11SVWldvoE1Ulpc', response.authorization
  #   assert_equal 5.0, response.params['value']
  #   assert_equal 'USD', response.params['currency']
  #   assert response.test?
  # end
  
  
  private
  # 
  # # Place raw successful response from gateway here
  def successful_authorize_response
    <<-RESPONSE
    <?xml version="1.0" encoding="utf-8" standalone="yes" ?>
    <paysafecard:PaysafecardTransaction xmlns:paysafecard="http://www.paysafecard.com/MerchantApi" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.paysafecard.com/MerchantApi MerchantApi_v1.xsd">
      <actionKey>com.psc.pay.CreateDispositionAction_1272988103184_24.22.29.22</actionKey>
      <txCode>0</txCode>
      <txMessage></txMessage>
      <MID>1060000037</MID>
      <MTID>cool-trans</MTID>
      <errCode>0</errCode>
      <errMessage></errMessage>
    </paysafecard:PaysafecardTransaction>
    RESPONSE
  end
  # 
  # # Place raw failed response from gateway here
  # def failed_response
  #   <<-RESPONSE
  #   <?xml version="1.0" encoding="UTF-8"?>
  #   <responseMobilePaymentProcessEntrypoints xmlns="http://pay01.zong.com/zongpay" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://pay01.zong.com/zongpay/zongpay.xsd"><countryCode>IQ</countryCode></responseMobilePaymentProcessEntrypoints>
  #   RESPONSE
  # end
  # 

end
