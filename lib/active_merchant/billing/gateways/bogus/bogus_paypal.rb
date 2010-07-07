# TODO copy me into the active_mechant project!
module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class BogusPaypalGateway < Gateway
      
      # We only care about reference transactions so not using purchase for the credit card stuff
      def purchase(token, credit_card_or_referenced_id, options = {})
        purchase_response
      end
      
      def purchase_response
        Response.new(true, '', purchase_results_params, :test => true, :authorization => purchase_results_params['transaction_id'])
      end
      
      def purchase_results_params
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
          "payment_status"=>"Pending",
          "pending_reason"=>"payment-review",
          "reason_code"=>"none",
          "protection_eligibility"=>"Ineligible"
        }
      end
    end
  end
end
