require File.dirname(__FILE__) + '/zong/helper.rb'
require File.dirname(__FILE__) + '/zong/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Zong 
        autoload :Helper, File.dirname(__FILE__) + '/zong/helper.rb'
        autoload :Notification, File.dirname(__FILE__) + '/zong/notification.rb'
       
        mattr_accessor :service_url
        self.service_url = 'https://www.example.com'

        def self.notification(post)
          Notification.new(post)
        end  
      end
    end
  end
end
