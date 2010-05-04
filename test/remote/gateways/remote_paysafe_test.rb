require 'test_helper'

class RemotePaysafeTest < Test::Unit::TestCase
  

  def setup
    @gateway = PaysafeGateway.new(fixtures(:paysafe))

    @gateway.initialize_merchant_data

    @options = { 
      :currency => 'EUR',
      :transaction_id => 'cool-trans',
      :amount => 10,
      :ok_url => 'http://www.kongregate.com/paysafe?ok=true',
      :nok_url => 'http://www.kongregate.com/paysafe?ok=false'
    }
  end
  
  def test_successful_authorize
    assert response = @gateway.authorize(@options)
    assert_instance_of Response, response
    assert_success response
  end

  def test_duplicate_transaction_id_authorize
    @gateway.authorize(@options)
    assert response = @gateway.authorize(@options)
    assert_instance_of Response, response
    assert_failure response
  end
  
  def test_successful_get_transaction_status
    @gateway.authorize(@options)
    
    assert response = @gateway.check_transaction_status(@options)
    assert_instance_of Response, response
    assert_success response
    
    assert_equal PaysafeGateway::DISPOSITION_CREATED, response.params['TransactionState']
  end
  
  def test_failed_get_transaction_status_when_bad_transaction_id
    assert response = @gateway.check_transaction_status(@options)
    assert_instance_of Response, response
    assert_failure response
  end
  
end
