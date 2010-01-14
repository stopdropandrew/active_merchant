require File.dirname(__FILE__) + '/zong/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Zong 
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
