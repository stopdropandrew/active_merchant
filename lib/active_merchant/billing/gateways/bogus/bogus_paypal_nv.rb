module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class BogusPaypalNvGateway < Gateway
      attr_accessor :fail_requests
      
      def purchase_from_reference_transaction(reference_id, money, options = {})
        if fail_requests
          Response.new(false, 'A super error message from paypal!', failure_results, :test => true )
        else
          Response.new(true, '', success_results, :test => true, :authorization => success_results["transactionid"] )
        end
      end
      
      def with_failed_response &block
        self.fail_requests = true
        yield
        self.fail_requests = false
      end
      
      private
      
      def failure_results
        {
          "timestamp"=>"2010-06-22T23:59:50Z", 
          "correlationid"=>"f006605c4f64", 
          "ack"=>"Failure", 
          "version"=>"50.0000", 
          "build"=>"1364891", 
          "l_errorcode0"=>"11451", 
          "l_shortmessage0"=>"Billing Agreement Id or transaction Id is not valid", 
          "l_longmessage0"=>"Billing Agreement Id or transaction Id is not valid", 
          "l_severitycode0"=>"Error"
        }
      end

      def success_results
        {
          "avscode"=>"X", 
          "cvv2_match"=>"M", 
          "timestamp"=>"2010-06-22T23:54:23Z", 
          "correlationid"=>"bd06451d1e0d8", 
          "ack"=>"Success", 
          "version"=>"50.0000", 
          "build"=>"1364891", 
          "transactionid"=>"0AG31868XH8452246", 
          "amt"=>"25.40", 
          "currencycode"=>"USD"
        }
      end
    end
  end
end