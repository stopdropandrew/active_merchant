module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class OfferpalGateway < Gateway
      IFRAME_URL = 'http://pub.myofferpal.com/<application_id>/showoffers.action?snuid=<user_id>'
      
      self.homepage_url = 'http://www.myofferpal.com/'
      self.display_name = 'Offerpal'
      
      def initialize(options = {})
        requires!(options, :application_id)
        @options = options
        super
      end  
      
      def iframe_url(user_id)
        IFRAME_URL.sub('<application_id>', options[:application_id]).sub('<user_id>', user_id.to_s)
      end
    end
  end
end

