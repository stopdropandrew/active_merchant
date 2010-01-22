require 'test_helper'

class ZongModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def test_notification_method
    assert_instance_of Zong::Notification, Zong.notification('name=cody')
  end
end 
