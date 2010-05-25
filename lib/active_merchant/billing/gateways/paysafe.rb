module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class PaysafeGateway < Gateway
      
      OUTPUT_FORMAT = 'xml_v1'
      
      # endpoints
      BASE_URL = "https://shops.%s.at.paysafecard.com/pscmerchant/%s"
      CUSTOMER_BASE_URL = "https://customer.%s.at.paysafecard.com/psccustomer/GetCustomerPanelServlet"      
      
      # test actions
      INITIALIZE_TEST_ACTION = 'InitializeMerchantTestDataServlet'

      # real actions
      AUTHORIZE_ACTION = "CreateDispositionServlet"
      CHECK_TRANSACTION_ACTION = "GetDispositionStateServlet"
      CAPTURE_ACTION = "DebitServlet"
      
      # disposition statuses
      DISPOSITION_CREATED = 'C'
      DISPOSITION_DISPOSED = 'D'
      DISPOSITION_EXPIRED = 'X'
      
      
      def initialize(options = {})
        requires!(options, :merchant_id, :currency, :business_type, :pem, :pem_password)
        @options = options
        
        @options[:ca_file] = File.dirname(__FILE__) + '/../../../certs/paysafecard-CA.pem'
        
        super
      end
      
      def initialize_merchant_data
        raise StandardError, "Can only initialize merchant test data in test mode" unless test?
        post = {}
        add_boilerplate_info(post)
        commit(INITIALIZE_TEST_ACTION, post)
      end
      
      def authorize(options = {})
        requires!(options, :transaction_id, :amount, :ok_url, :nok_url)
        post = {}
        add_boilerplate_info(post)
        add_transaction_data(post, options)
        add_purchase_data(post, options)
        add_ok_urls(post, options)
        
        commit(AUTHORIZE_ACTION, post)
      end
      
      def check_transaction_status(options = {})
        requires!(options, :transaction_id)
        post = {}
        
        add_boilerplate_info(post)
        add_transaction_data(post, options)
        
        commit(CHECK_TRANSACTION_ACTION, post)
      end
      
      def capture(options = {})
        requires!(options, :transaction_id, :amount)
        post = { :close => 1 }
        add_boilerplate_info(post)
        add_transaction_data(post, options)
        add_purchase_data(post, options)
        
        commit(CAPTURE_ACTION, post)
      end
      
      def customer_iframe_url(options = {})
        requires!(options, :transaction_id, :amount)
        base_url = customer_url
        
        params = {}
        add_boilerplate_info(params)
        add_transaction_data(params, options)
        add_purchase_data(params, options)
        
        base_url + '?' + params.to_query
      end
      
      private

      def add_boilerplate_info(post)
        post[:mid] = @options[:merchant_id]
        post[:outputFormat] = OUTPUT_FORMAT
      end

      def add_transaction_data(post, options)
        post[:mtid] = options[:transaction_id]
      end
      
      def add_purchase_data(post, options)
        post[:currency] = @options[:currency]
        post[:amount] = '%.2f' % options[:amount]
        post[:businesstype] = @options[:business_type]
        post[:reportingcriteria] = options[:reportingcriteria]
      end

      def add_ok_urls(post, options)
        post[:okurl] = options[:ok_url]
        post[:nokurl] = options[:nok_url]
      end
      
      def commit(action, parameters)
        response = parse( ssl_post( api_url(action), post_data(parameters) ) )

        Response.new(response['errCode'] == '0', response['errMessage'], response,
          :authorization => response["MTID"],
          :test => test?
        )
      end
      
      def post_data(paramaters = {})
        paramaters.map {|key,value| "#{key}=#{CGI.escape(value.to_s)}"}.join("&")
      end

      def parse(xml)
        doc = REXML::Document.new(xml)
        hash = doc.root.elements.inject(nil, {}) do |a, node|
          a[node.name] = node.text
          a
        end
        
        hash
      end

      def api_url(action)
        merchant_id = test? ? 'test' : options[:merchant_id]
        BASE_URL % [ merchant_id, action ]
      end

      def customer_url
        merchant_id = test? ? 'test' : options[:merchant_id]
        CUSTOMER_BASE_URL % merchant_id
      end

    end
  end
end