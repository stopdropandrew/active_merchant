require 'test_helper'

class RemoteZongTest < Test::Unit::TestCase
  

  def setup
    @gateway = ZongGateway.new(fixtures(:zong))

    @options = { 
      :country_code => 'US',
      :currency => 'USD'
    }
  end
  
  def test_invalid_customer_key
    @gateway = ZongGateway.new(:customer_key => 'test')
    assert_raises ActiveMerchant::ResponseError do 
      @gateway.lookup_price_points(@options)
    end
  end
  
  def test_invalid_country_code
    assert_raises ActiveMerchant::ResponseError do 
      @gateway.lookup_price_points(@options.merge(:country_code => 'asdfwe'))
    end
  end

  def test_unsupported_country_code
    assert_failure @gateway.lookup_price_points(@options.merge(:country_code => 'IQ'))
  end

  def test_valid_country_code
    response = @gateway.lookup_price_points(@options.merge(:country_code => 'US'))
    assert_success response
    
    items = response.params['items']
    assert items.map{ |h| h[:working_price]}.all?{ |v| v.is_a?(Float) }
    assert items.map{ |h| h[:out_payment]}.all?{ |v| v.is_a?(Float) }
    assert items.map{ |h| h[:item_ref]}.all?{ |v| v.is_a?(String) }
    assert items.map{ |h| h[:zong_plus_only]}.all?{ |v| v.is_a?(FalseClass) || v.is_a?(TrueClass) }
    assert items.map{ |h| h[:entrypoint_url]}.all?{ |v| v.is_a?(String) && 0 == v.index("https://") }
  end
  
end
