require 'test_helper'

class OfferpalModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  Offerpal.application_id = '153ddfb15ae1e37b7cf004b201c3e3fd'
  
  def test_iframe_url_requires_application_id
    old_app_id = Offerpal.application_id
    Offerpal.application_id = nil
    assert_raises RuntimeError do
      Offerpal.iframe_url(1234)
    end
    Offerpal.application_id = old_app_id
  end
  
  def test_iframe_url
    assert_equal "http://pub.myofferpal.com/153ddfb15ae1e37b7cf004b201c3e3fd/showoffers.action?snuid=1234", Offerpal.iframe_url(1234)
  end

  def test_status_iframe_url_requires_application_id
    old_app_id = Offerpal.application_id
    Offerpal.application_id = nil
    assert_raises RuntimeError do
      Offerpal.status_iframe_url(1234)
    end
    Offerpal.application_id = old_app_id
  end
  
  def test_status_iframe_url
    assert_equal "http://pub.myofferpal.com/153ddfb15ae1e37b7cf004b201c3e3fd/userstatus.action?snuid=1234", Offerpal.status_iframe_url(1234)
  end
end 
