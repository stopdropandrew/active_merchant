module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class BogusUltimatepayUgcGateway < Gateway
      def authorize(options = {})
        case options[:ugc_pin]
        when '9999'
          Response.new(true, '', {}, :test => true, :authorization => rand(10000).to_s )
        when '8888'
          Response.new(true, '', {}, :test => true, :authorization => '10001' )
        else
          Response.new(false, 'Invalid pin', {}, :test => true )
        end
      end
      
      def capture(options = {})
        case options[:token]
        when '10001'
          Response.new(false, 'Invalid token', {}, :test => true )
        else
          Response.new(true, '', {}, :test => true )
        end
      end
    end
  end
end
