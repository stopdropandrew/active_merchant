require 'test_helper'

class RemoteUltimatepayUgcTest < Test::Unit::TestCase
  def setup
    @gateway = UltimatepayUgcGateway.new(fixtures(:ultimatepay_ugc))
    
    @amount = 1.00

    options = {
      :user_id => 1,
    }
    
    @success_pin = options.merge( :ugc_pin => fixtures(:ultimatepay_ugc)[:valid_pin] )
    @failure_pin = options.merge( :ugc_pin => '1234567' )
  end
  
  def x_test_successful_purchase
    assert response = @gateway.purchase(@amount, @success_pin)
    assert_success response
    assert_equal 'REPLACE WITH SUCCESS MESSAGE', response.message
  end

  def test_unsuccessful_purchase
    assert response = @gateway.purchase(@amount, @failure_pin)
    assert_failure response
    assert_equal 'Invalid pin', response.message
  end
end
