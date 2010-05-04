require 'test_helper'

class RemotePaysafeTest < Test::Unit::TestCase
  

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
  
  def test_get_response
    assert @gateway.authorize(@options)
  end
end
