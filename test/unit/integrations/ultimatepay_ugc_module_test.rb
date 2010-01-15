require 'test_helper'

class UltimatepayUgcModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def test_notification_method
    assert_instance_of UltimatepayUgc::Notification, UltimatepayUgc.notification('name=cody')
  end
end 
