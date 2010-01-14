require File.dirname(__FILE__) + '/ultimatepay_ugc/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module UltimatepayUgc 
        def self.notification(post)
          Notification.new(post)
        end  
      end
    end
  end
end
