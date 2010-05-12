require 'test_helper'

class ZongTest < Test::Unit::TestCase
  def setup
    @gateway = ZongGateway.new(:customer_key => 'test')

    @options = { 
      :country_code => 'US',
      :currency => 'USD'
    }
    
    @entry_point_1 = "https://pay01.zong.com/zongpay/actions/processing?purchaseKey=eNqrcAwOYrw1f1PWj09TNDesLKpWCvBWsqpWKihQslKytNSztDQwUNJRSi4FckODXYDMokyETDxECKi2pKg0FagMKGdoAKTBqpVqawHpfxxm"
        
    @entry_point_2 = "https://pay01.zong.com/zongpay/actions/processing?purchaseKey=eNrTXbrogUvbtpPOPfaFnY8CkquVAryVrKqVCgqUrJSM9SwtDQyUdJSSS4G80GAXILMoEy4RDxEBqiwpKk0FqgJKGRoAabBipdpaAKrYG7w%3D"
    
  end
  
  def test_lookup_price_points
    @gateway.expects(:ssl_post).returns(successful_response)
    
    assert response = @gateway.lookup_price_points(@options)
    assert_instance_of Response, response
    assert_success response
    
    items = response.params['items']
    
    assert_equal [3.99, 99.99], items.map{|h| h[:working_price]}.sort
    assert_equal [3.45, 87.10], items.map{|h| h[:out_payment]}.sort
    assert_equal ['3.9900_USD', '99.9900_USD'], items.map{|h| h[:item_ref]}.sort
    assert_equal [true, true], items.map{|h| h[:zong_plus_only]}
    assert_equal [@entry_point_1, @entry_point_2], items.map{|h| h[:entrypoint_url]}.sort
    assert_equal 'all', items.first[:supported_providers]
    assert_equal ['ATT'], items.last[:supported_providers]
  end

  def test_unsuccessful_request
    @gateway.expects(:ssl_post).returns(failed_response)

    @options['country_code'] = 'IQ'
    assert response = @gateway.lookup_price_points(@options)
    assert_failure response
  end

  private
  
  # Place raw successful response from gateway here
  def successful_response
    <<-RESPONSE
    <?xml version="1.0" encoding="UTF-8"?>
    <responseMobilePaymentProcessEntrypoints xmlns="http://pay01.zong.com/zongpay" 
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://pay01.zong.com/zongpay/zongpay.xsd">
      <countryCode>US</countryCode> 
      <items>
        <item priceMatched="true" exactPrice="3.9900" workingPrice="3.9900" outPayment="3.4500" numMt="1" itemRef="3.9900_USD" zongPlusOnly="true">
          <supportedProviders all="true"/>
          <entrypointUrl>#{@entry_point_1}</entrypointUrl>
        </item>
        <item priceMatched="true" exactPrice="99.9900" workingPrice="99.9900" outPayment="87.1000" numMt="1" itemRef="99.9900_USD" zongPlusOnly="true">
          <supportedProviders>
            <provider id="310410" name="ATT"/>
          </supportedProviders>
          <entrypointUrl>#{@entry_point_2}</entrypointUrl>
        </item>
      </items>
    </responseMobilePaymentProcessEntrypoints>
    RESPONSE
  end
  
  # Place raw failed response from gateway here
  def failed_response
    <<-RESPONSE
    <?xml version="1.0" encoding="UTF-8"?>
    <responseMobilePaymentProcessEntrypoints xmlns="http://pay01.zong.com/zongpay" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://pay01.zong.com/zongpay/zongpay.xsd"><countryCode>IQ</countryCode></responseMobilePaymentProcessEntrypoints>
    RESPONSE
  end


end
