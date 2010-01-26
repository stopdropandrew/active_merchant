require 'test_helper'

class OfferpalTest < Test::Unit::TestCase
  def setup
    @gateway = OfferpalGateway.new(
                 :application_id => '153ddfb15ae1e37b7cf004b201c3e3fd'
               )
  end
  
  def test_iframe_url
    assert_equal "http://pub.myofferpal.com/153ddfb15ae1e37b7cf004b201c3e3fd/showoffers.action?snuid=1234", @gateway.iframe_url(1234)
  end
end
