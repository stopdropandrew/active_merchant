require 'test_helper'

class UltimatepayUgcTest < Test::Unit::TestCase
  def setup
    @gateway = UltimatepayUgcGateway.new(
                 :merchant_code => 'UC04',
                 :login => 'login',
                 :password => 'password',
                 :secret_phrase => '5ebe2294ecd0e0f08eab7690d2a6ee69'
               )

    @purchase_options = {
      :user_id => 1,
      :ugc_pin => '99999999999'
    }
    @amount = 1.00
    
  end
  
  def test_valid_login?
    assert !@gateway.valid_login?('login', 'wrong')
    assert !@gateway.valid_login('wrong', 'password')
    assert @gateway.valid_login('login', 'password')
  end
  
  def test_successful_purchase
    @gateway.expects(:ssl_post).returns(successful_purchase_response)
    
    assert response = @gateway.purchase(@amount, @purchase_options)
    assert_instance_of Response, response
    assert_success response
    
    # Replace with authorization number from the successful response
    assert_equal '%7Bcc67f1e4-2ee8-4ce0-a147-498fc411d76c%7D', response.authorization
    assert response.test?
  end

  def test_unsuccessful_request
    @gateway.expects(:ssl_post).returns(failed_purchase_response)
    
    assert response = @gateway.purchase(@amount, @purchase_options)
    assert_instance_of Response, response
    assert_failure response
    assert response.test?
  end

  private
  
  # Place raw successful response from gateway here
  def successful_purchase_response
    [
      'token=BMhFnN4SohBrWODtHZn62GTAx3tm11SVWldvoE1Ulpc',
      'result=paid',
      'error_detail=',
      'set_amount=1.00',
      'currency=USD',
      'pbctrans=%7Bcc67f1e4-2ee8-4ce0-a147-498fc411d76c%7D'
    ].join('&')
  end
  
  # Place raw failed response from gateway here
  def failed_purchase_response
    'token=6h85pxerDfjwRMSmIAae3lXLXbkE87xjZxy9ytE1bW&result=failed&errorDetail=ugc_pin'
  end
end
