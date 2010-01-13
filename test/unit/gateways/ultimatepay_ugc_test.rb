require 'test_helper'

class UltimatepayUgcTest < Test::Unit::TestCase
  def setup
    @gateway = UltimatepayUgcGateway.new(
                 :merchant_code => 'UC04',
                 :login => 'login',
                 :password => 'password',
                 :secret_phrase => '5ebe2294ecd0e0f08eab7690d2a6ee69'
               )

    @authorize_options = {
      :user_id => 1,
      :username => 'shredmasterfresh',
      :ugc_pin => '99999999999',
      :merchtrans => 'asdf123'
    }
    
    @capture_options = {
      :token => 'iONyv5B13mKRTNtuYHxvV6wUuHz8fZrt9uKcGW90dJx',
      :ugc_pin => '99999999999'
    }
    
  end
  
  def test_valid_login?
    assert !@gateway.valid_login?('login', 'wrong')
    assert !@gateway.valid_login?('wrong', 'password')
    assert @gateway.valid_login?('login', 'password')
  end
  
  def test_successful_authorize
    @gateway.expects(:ssl_post).returns(successful_authorize_response)
    
    assert response = @gateway.authorize(@authorize_options)
    assert_instance_of Response, response
    assert_success response
    
    # Replace with authorization number from the successful response
    assert_equal 'BMhFnN4SohBrWODtHZn62GTAx3tm11SVWldvoE1Ulpc', response.authorization
    assert_equal 5.0, response.params['value']
    assert_equal 'USD', response.params['currency']
    assert response.test?
  end

  def test_unsuccessful_authorize
    @gateway.expects(:ssl_post).returns(failed_authorize_response)
    
    assert response = @gateway.authorize(@authorize_options)
    assert_instance_of Response, response
    assert_failure response
    assert response.test?
  end

  def test_successful_capture
    @gateway.expects(:ssl_post).returns(successful_capture_response)
    
    assert response = @gateway.capture(@capture_options)
    assert_instance_of Response, response
    assert_success response
    
    # Replace with authorization number from the successful response
    assert_equal 'BMhFnN4SohBrWODtHZn62GTAx3tm11SVWldvoE1Ulpc', response.authorization
    assert response.test?
  end

  def test_unsuccessful_capture
    @gateway.expects(:ssl_post).returns(failed_capture_response)
    
    assert response = @gateway.capture(@capture_options)
    assert_instance_of Response, response
    assert_failure response
    assert response.test?
  end

  private
  
  def successful_authorize_response
    [
      'token=BMhFnN4SohBrWODtHZn62GTAx3tm11SVWldvoE1Ulpc',
      'result=auth',
      'status=active',
      'value=5',
      'currency=USD'
    ].join('&')
  end
  
  def failed_authorize_response
    'token=6h85pxerDfjwRMSmIAae3lXLXbkE87xjZxy9ytE1bW&result=failed&errorDetail=ugc_pin'
  end
  
  def successful_capture_response
    "token=BMhFnN4SohBrWODtHZn62GTAx3tm11SVWldvoE1Ulpc&result=paid"
  end

  def failed_capture_response
    'token=6h85pxerDfjwRMSmIAae3lXLXbkE87xjZxy9ytE1bW&result=failed&errorDetail=ugc_pin'
  end
end
