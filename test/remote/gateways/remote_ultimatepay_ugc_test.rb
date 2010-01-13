require 'test_helper'

class RemoteUltimatepayUgcTest < Test::Unit::TestCase
  def setup
    @gateway = UltimatepayUgcGateway.new(fixtures(:ultimatepay_ugc))
    
    options = {
      :user_id => 1,
    }
    
    @success_pin = options.merge( :ugc_pin => fixtures(:ultimatepay_ugc)[:valid_pin] )
    @failure_pin = options.merge( :ugc_pin => '1234567' )
  end
  
  def x_test_successful_authorize
    assert response = @gateway.authorize(@success_pin)
    assert_success response
    assert_equal 'REPLACE WITH SUCCESS MESSAGE', response.message
  end

  def test_unsuccessful_authorize
    assert response = @gateway.authorize(@failure_pin)
    assert_failure response
    assert_equal 'Invalid pin', response.message
  end

  def x_test_successful_capture
    assert response = @gateway.authorize(@success_pin.merge(:token => 'succesful token'))
    assert_success response
    assert_equal 'REPLACE WITH SUCCESS MESSAGE', response.message
  end

  def test_unsuccessful_capture
    assert response = @gateway.capture(@failure_pin.merge(:token => '99999999999'))
    assert_failure response
    assert_equal 'Invalid token', response.message
  end
end
