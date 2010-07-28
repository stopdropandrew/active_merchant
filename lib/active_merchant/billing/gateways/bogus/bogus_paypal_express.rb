require File.join(File.dirname(__FILE__), '../paypal/paypal_express_response')

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class BogusPaypalExpressGateway < Gateway
      TEST_REDIRECT_URL = 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token='
      SETUP_TOKEN = "EC-09U03228KE464884V"
      
      def setup_purchase(amount, options = {})
        setup_purchase_response
      end
      
      def redirect_url_for(token, options = {})
        TEST_REDIRECT_URL + token
      end
      
      def details_for(token, options = {})
        PaypalExpressResponse.new(true, '', details_results, :test => true, :authorization => nil)
      end
      
      def purchase(token, options = {})
        PaypalExpressResponse.new(true, '', purchase_results, :test => true, :authorization => purchase_results['transaction_id'])
      end
      
      def setup_purchase_response
        PaypalExpressResponse.new(true, '', setup_results, :test => true, :authorization => nil)
      end
      
      def with_pending_response
        @do_pending = true
        yield
        @do_pending = false
      end
      
      def paypal_email
        details_results['payer']
      end
      
      def country_name
        details_results['country_name']
      end
      
      def setup_results
        {
          "timestamp"=>"2010-06-29T00:02:10Z", 
          "ack"=>"Success", 
          "correlation_id"=>"b2103034b98a4", 
          "version"=>"59.0", 
          "build"=>"1366358", 
          "token"=> SETUP_TOKEN
        }
      end
      
      def details_results
        {
          "timestamp"=>"2010-06-30T23:04:53Z", 
          "ack"=>"Success", 
          "correlation_id"=>"e2daf16de50b", 
          "version"=>"59.0", 
          "build"=>"1366358", 
          "token"=>"EC-09U03228KE464884V", 
          "payer"=>"buyer_1218148336_per@kongregate.com", 
          "payer_id"=>"QRNZ4X6UPWP7N", 
          "payer_status"=>"verified", 
          "salutation"=>nil, 
          "first_name"=>"Test", 
          "middle_name"=>nil, 
          "last_name"=>"User", 
          "suffix"=>nil, 
          "payer_country"=>"US", 
          "payer_business"=>nil, 
          "name"=>"Test User", 
          "street1"=>"1 Main St", 
          "street2"=>nil, 
          "city_name"=>"San Jose", 
          "state_or_province"=>"CA",
          "country"=>"US",
          "country_name"=>"United States",
          "phone"=>nil,
          "postal_code"=>"95131",
          "address_owner"=>"PayPal",
          "address_status"=>"Confirmed",
          "invoice_id"=>"0ddc23b9-16ac-4cf8-ac38-b4485db6c0e6",
          "order_total"=>"10.00",
          "order_total_currency_id"=>"USD",
          "shipping_total"=>"0.00",
          "shipping_total_currency_id"=>"USD",
          "handling_total"=>"0.00",
          "handling_total_currency_id"=>"USD",
          "tax_total"=>"0.00",
          "tax_total_currency_id"=>"USD",
          "order_description"=>"110 kreds",
          "address_id"=>nil,
          "external_address_id"=>nil,
          "insurance_total"=>"0.00",
          "insurance_total_currency_id"=>"USD",
          "shipping_discount"=>"0.00",
          "shipping_discount_currency_id"=>"USD"
        }
      end
      
      def purchase_results
        {
          "timestamp"=>"2010-07-01T00:04:18Z",
          "ack"=>"Success",
          "correlation_id"=>"702052229be70",
          "version"=>"59.0",
          "build"=>"1366358",
          "token"=>"EC-09U03228KE464884V",
          "transaction_id"=>"6DT53448C0184102B",
          "parent_transaction_id"=>nil,
          "receipt_id"=>nil,
          "transaction_type"=>"express-checkout",
          "payment_type"=>"instant",
          "payment_date"=>"2010-07-01T00:04:17Z",
          "gross_amount"=>"10.00",
          "gross_amount_currency_id"=>"USD",
          "fee_amount"=>"0.59",
          "fee_amount_currency_id"=>"USD",
          "tax_amount"=>"0.00",
          "tax_amount_currency_id"=>"USD",
          "exchange_rate"=>nil,
          "payment_status"=> (@do_pending ? "Pending" : "Completed"),
          "pending_reason"=> (@do_pending ? "payment-review" : "none"),
          "reason_code"=>"none",
          "protection_eligibility"=>"Ineligible",
          "billing_agreement_id"=>"ABASJD21323SJS"
        }
      end
    end
  end
end