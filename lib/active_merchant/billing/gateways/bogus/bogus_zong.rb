module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class BogusZongGateway < Gateway
      self.supported_countries = ['US']

      def initialize(options = {})
        requires!(options, :customer_key)
        @options = options
        super
      end 
      
      def lookup_price_points(options = {})
        case options[:country_code]
        when 'US'
          Response.new(true, '', {:items => results }, :test => true )
        when 'IQ'
          Response.new(false, '', {:items => []}, :test => true )
        else
          Response.new(false, 'Invalid country', {}, :test => true )
        end
      end
      
      def results
        [
          {
            :working_price => 5.75, 
            :out_payment => 3.01, 
            :item_ref  => '5.7500_USD', 
            :zong_plus_only => false, 
            :entrypoint_url => 'http://www.zong.com?purchaseKey=1234'
          },
          {
            :working_price => 8.75, 
            :out_payment => 5.01, 
            :item_ref  => '8.7500_USD', 
            :zong_plus_only => false, 
            :entrypoint_url => 'http://www.zong.com?purchaseKey=8888'
          }
        ]
      end
    end
  end
end
