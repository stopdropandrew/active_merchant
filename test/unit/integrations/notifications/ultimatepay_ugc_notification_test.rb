require 'test_helper'

class UltimatepayUgcNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    
    @gateway = UltimatepayUgcGateway.new(fixtures(:ultimatepay_ugc))
    @ultimatepay_ugc = UltimatepayUgc::Notification.new(http_raw_data, :gateway => @gateway)
  end

  def test_invalid_login_response
    @ultimatepay_ugc.stubs(:valid_login?).returns(false)
    
    response = parse_response(@ultimatepay_ugc.response)
    assert_equal '[ERROR]', response[:result]
    assert_equal 'Invalid_Login', response[:reason]
  end

  def test_invalid_hash_response
    @ultimatepay_ugc.stubs(:valid_hash?).returns(false)
    
    response = parse_response(@ultimatepay_ugc.response)
    assert_equal '[ERROR]', response[:result]
    assert_equal 'Invalid_Hash', response[:reason]
  end
  
  def test_invalid_commtype_response
    @ultimatepay_ugc.stubs(:valid_commtype?).returns(false)
    
    response = parse_response(@ultimatepay_ugc.response)
    assert_equal '[ERROR]', response[:result]
    assert_equal 'Internal_Error', response[:reason]
  end
  
  def test_successful
    @response = parse_response(@ultimatepay_ugc.response)
    assert_equal '[OK]', @response[:result]
    assert_equal '[N/A]', @response[:reason]
  end

  def test_valid_commtype?
    assert @ultimatepay_ugc.valid_commtype?
    
    assert !UltimatepayUgc::Notification.new('').valid_commtype?
  end

  def test_valid_hash?
    flunk
  end
  
  def test_valid_login?
    assert @ultimatepay_ugc.valid_login?

    assert !UltimatepayUgc::Notification.new('', :gateway => @gateway).valid_login?
  end

  def test_accessors
    assert_equal 1, @ultimatepay_ugc.user_id
    assert_equal "%7Ba75aea26-5dfc-42dd-aac5-cbed1531050c%7D", @ultimatepay_ugc.transaction_id
    assert_equal 'shredmasterfresh', @ultimatepay_ugc.username
    assert_equal 5, @ultimatepay_ugc.amount
    assert_equal "USD", @ultimatepay_ugc.currency
    assert_equal Time.parse("1/6/2010 18:03:00"), @ultimatepay_ugc.received_at
  end

  private
  def parse_response(response)
    response_array = response.split('|')
    {
      :result => response_array[0],
      :timestamp => response_array[1],
      :transaction_id => response_array[2],
      :reason => response_array[3]
    }
  end
  
  def post_data
    fixture_hash = fixtures(:ultimatepay_ugc)
    
    params = {
      "login"       => fixture_hash[:login], 
      "adminpwd"    => fixture_hash[:password], 
      "userid"      => "1", 
      "accountname" => "shredmasterfresh", 
      "pbctrans"    => "%7Ba75aea26-5dfc-42dd-aac5-cbed1531050c%7D", 
      "paymentid"   => "UG", 
      "sn"          => "KONG", 
      "set_amount"  => "4.00",
      "sepamount"   => "5.00", 
      "amount"      => "0.00", 
      "merchtrans"  => nil, 
      "dtdatetime"  => "20100106180300", 
      "rescode"     => nil, 
      "livemode"    => nil, 
      "detail"      => "SINGLE_PURCHASE", 
      "currency"    => "USD", 
      "commtype"    => "PAYMENT", 
      "gwtid"       => nil, 
      "mirror"      => nil, 
      "pkgid"       => "none"
    }

    hash = Digest::MD5.hexdigest(s = [
      params['userid'],
      params['adminpwd'],
      fixture_hash[:secret_phrase],
      params['pkgid'],
      params['currency'],
      params['amount'],
      params['paymentid']
    ].join)

    params["hash"] = hash
    params
  end
  
  def http_raw_data(params = post_data)
    params.map{|key,value| "#{key}=#{CGI.escape(value.to_s)}"}.join("&")
  end 
end
