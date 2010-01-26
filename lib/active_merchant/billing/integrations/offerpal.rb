require File.dirname(__FILE__) + '/offerpal/notification.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Offerpal 
       
        IFRAME_URL = 'http://pub.myofferpal.com/<application_id>/showoffers.action?snuid=<user_id>'

        mattr_accessor :application_id

        def self.iframe_url(user_id)
          raise "application_id must be set to generate an iframe url" if application_id.nil?
          IFRAME_URL.sub('<application_id>', application_id).sub('<user_id>', user_id.to_s)
        end

        def self.notification(post)
          Notification.new(post)
        end  
      end
    end
  end
end
