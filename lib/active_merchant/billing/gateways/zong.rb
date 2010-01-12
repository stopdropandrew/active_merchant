module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    # The Zong Gateway is only used for Process Entrypoint lookup calls
    # This API call returns iframe urls for each price point
    class ZongGateway < Gateway
      URL = 'https://pay01.zong.com/zongpay/actions/default'
      ZONG_NAMESPACES = { 'xmlns' => 'http://pay01.zong.com/zongpay',
                          'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                          'xmlns:schemaLocation' => 'http://pay01.zong.com/zongpay/zongpay.xsd'
                        }
      
      # The countries the gateway supports merchants from as 2 digit ISO country codes
      self.supported_countries = %w{ US CA AT AU BE CH CL CO CZ DE DK ES FI FR GB HU IE MX NL NO PL PT RU SE TR ZA }
      
      # The card types supported by the payment gateway
      self.supported_cardtypes = []
      
      # The homepage URL of the gateway
      self.homepage_url = 'http://www.zong.com/'
      
      # The name of the gateway
      self.display_name = 'Zong Gateway'
      
      def initialize(options = {})
        requires!(options, :customer_key)
        @options = options
        super
      end
      
      # makes requestMobilePaymentProcessEntrypoints call to Zong
      # returns a hash with keys: 
      #   :country_code = acknowledgement of country code for this list
      #   :items = array of item hashes with keys: 
      #       :working_price = what user will be charged
      #       :out_payment = what Zong will pay according to contract
      #       :item_ref = an item reference
      #       :zong_plus_only = true if this is available to Zong+ users only
      #       :entry_point_url = the iframe entry point url
      def lookup_price_points(options)
        requires!(options, :country_code, :currency)
        
        post = { :method => 'lookup'}
        add_lookup_xml(post, options)
        response = parse(ssl_post(URL, post_data(post)))
        
        Response.new(!!response[:items], nil, response)
      end
          
      private                       
      
      def add_lookup_xml(post, options)
        xml = Builder::XmlMarkup.new :indent => 2
        xml.tag! 'requestMobilePaymentProcessEntrypoints', ZONG_NAMESPACES do
          xml.tag! 'customerKey', customer_key 
          xml.tag! 'countryCode', options[:country_code]
          xml.tag! 'items', :currency => options[:currency]
        end

        post[:request] = xml.target!.to_s
      end
      
      def customer_key
        @options[:customer_key]
      end

      def post_data(paramaters = {})
        paramaters.map{ |k, v| "#{k}=#{CGI.escape(v.to_s)}"}.join("&")
      end

      def parse(xml)
        response = {}
        doc = REXML::Document.new(xml)
        response[:country_code] = doc.root.elements['countryCode'].text
        items = doc.root.elements['items']
        
        return {} unless items # early exit if no items, country code not found
        item_array = []
        
        items.each_element do |item|
          entry_point_url = item.elements['entrypointUrl'].text
          item_array << { :working_price => item.attributes['workingPrice'].to_f, 
                          :out_payment => item.attributes['outPayment'].to_f, 
                          :item_ref  => item.attributes['itemRef'], 
                          :zong_plus_only => item.attributes['zongPlusOnly'] == 'true', 
                          :entrypoint_url => entry_point_url
                        }
        end
        
        response[:items] = item_array
        response
      end     
      
     end
  end
end

