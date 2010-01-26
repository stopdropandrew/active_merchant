require 'test_helper'

class OfferpalNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @offerpal = Offerpal::Notification.new(http_raw_data)
  end

  def test_accessors
    assert @offerpal.complete?
    assert_equal "", @offerpal.status
    assert_equal "", @offerpal.transaction_id
    assert_equal "", @offerpal.item_id
    assert_equal "", @offerpal.gross
    assert_equal "", @offerpal.currency
    assert_equal "", @offerpal.received_at
    assert @offerpal.test?
  end

  def test_compositions
    assert_equal Money.new(3166, 'USD'), @offerpal.amount
  end

  # Replace with real successful acknowledgement code
  def test_acknowledgement    

  end

  def test_send_acknowledgement
  end

  def test_respond_to_acknowledge
    assert @offerpal.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    ""
  end  
end
