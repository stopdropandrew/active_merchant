require File.dirname(__FILE__) + '/paypal_nv/paypal_nv_common_api'
require File.dirname(__FILE__) + '/paypal_express_nv'

# This was fished out of a really old version of ActiveMerchant and should 
# be used ONLY for purchase_from_reference_transaction calls!
module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class PaypalNvGateway < Gateway
      include PaypalNvCommonAPI

      self.supported_cardtypes = [:visa, :master, :american_express, :discover]
      self.supported_countries = ['US']
      self.homepage_url = 'https://www.paypal.com/cgi-bin/webscr?cmd=_wp-pro-overview-outside'
      self.display_name = 'PayPal Website Payments Pro (US)'

      def authorize(money, credit_card, options = {})
        requires!(options, :ip)
        commit 'DoDirectPayment', build_sale_or_authorization_request('Authorization', money, credit_card, options)
      end

      def purchase(money, credit_card, options = {})
        requires!(options, :ip)
        commit 'DoDirectPayment', build_sale_or_authorization_request('Sale', money, credit_card, options)
      end

      def express
        @express ||= PaypalExpressNvGateway.new(@options)
      end
      
      def purchase_from_reference_transaction(reference_id, money, options = {})
        commit 'DoReferenceTransaction', build_reference_transaction_purchase_request('Sale', money, reference_id, options)
      end

      private

      def build_sale_or_authorization_request(action, money, credit_card_or_reference, options)
        post = {}
        post[:paymentaction] = action
        post[:buttonsource] = application_id.to_s.slice(0,32) unless application_id.blank?
        add_addresses(post, options)
        add_customer_data(post, options)
        add_invoice(post, options)
        add_credit_card(post, credit_card_or_reference)
        add_amount(post, money, options)
        add_subtotals(post, options)
        post
      end
      
      def build_reference_transaction_purchase_request(action, money, reference_id, options)
        post = {}
        post[:paymentaction] = action
        post[:buttonsource] = application_id.to_s.slice(0,32) unless application_id.blank?
        post[:referenceid] = reference_id
        add_amount(post, money, options)
        post
      end

      def credit_card_type(type)
        case type
        when 'visa'             then 'Visa'
        when 'master'           then 'MasterCard'
        when 'discover'         then 'Discover'
        when 'american_express' then 'Amex'
        when 'switch'           then 'Switch'
        when 'solo'             then 'Solo'
        end
      end

      def build_response(success, message, response, options = {})
         Response.new(success, message, response, options)
      end
    end
  end
end
