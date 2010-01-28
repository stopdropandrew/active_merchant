module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class UltimatepayUgcGateway < Gateway
      # we'll use the live url for tests until they get a real test gateway
      TEST_URL = 'https://www.ultimatepay.com/app/api/live/'
      LIVE_URL = 'https://www.ultimatepay.com/app/api/live/'
      
      AUTHORIZE_METHOD = 'StartOrderDirect'
      AUTHORIZE_SUCCESS = 'auth'
      CAPTURE_METHOD = 'Commit'
      CAPTURE_SUCCESS = 'paid'
      
      self.default_currency = 'USD'
      
      # The homepage URL of the gateway
      self.homepage_url = 'http://www.ultimatepay.com/'
      
      # The name of the gateway
      self.display_name = 'Ultimatepay UGC Gateway'
      
      def initialize(options = {})
        requires!(options, :merchant_code, :password, :secret_phrase, :login)
        @options = options
        super
      end 
      
      def authorize(options = {})
        requires!(options, :user_id, :username, :ugc_pin, :merchtrans)
        post = {}
        add_boilerplate_info(post, options)
        add_merchtrans(post, options)
        add_customer_data(post, options)
        add_hash(post)
        
        commit(AUTHORIZE_METHOD, post)
      end
      
      def capture(options = {})
        requires!(options, :token, :ugc_pin, :currency, :amount)
        post = {}
        add_boilerplate_info(post, options)
        add_token(post, options)
        add_amount(post, options)
        
        commit(CAPTURE_METHOD, post)
      end

      private
      
      def add_boilerplate_info(post, options)
        post[:sn] = @options[:merchant_code]
        post[:paymentid] = 'UG'
        post[:ugc_pin] = options[:ugc_pin]
      end

      def add_merchtrans(post, options)
        post[:merchtrans] = options[:merchtrans]
      end

      def add_token(post, options)
        post[:token] = options[:token]
      end

      def add_amount(post, options)
        post[:currency] = options[:currency]
        post[:amount] = options[:amount]
      end
      
      def add_amount(post, options)
        post[:amount] = options[:amount]
      end
      
      def add_customer_data(post, options)
        post[:userid] = options[:user_id]
        post[:accountname] = options[:username]
      end
      
      def add_hash(post)
        hash = Digest::MD5.hexdigest(s = [
          post[:userid],
          @options[:password],
          @options[:secret_phrase],
          post[:pkgid],
          post[:currency],
          post[:amount],
          post[:paymentid],
          post[:merchtrans],
          post[:riskmode],
          post[:developerid],
          post[:appid]
        ].join)
        post[:hash] = hash
      end
      
      def commit(method, parameters)
        parameters[:method] = method
        
        response = parse( ssl_post(gateway_url, post_data(parameters) ) )

        success = case method
        when AUTHORIZE_METHOD
          response['result'] == AUTHORIZE_SUCCESS
        when CAPTURE_METHOD
          response['result'] == CAPTURE_SUCCESS
        end
        
        Response.new(success, message_from(response['errorDetail']), response, 
          :authorization => response["token"],
          :test => test?
        )
      end

      def parse(body)
        results = {}
        body.split('&').each do |pair|
          key,val = pair.split('=')
          results[key] = val
        end
        
        results['value'] = results['value'].to_f if results['value']
        
        results
      end
      
      def message_from(response)
        case response
        when 'ugc_pin'
          'Invalid pin'
        when 'token'
          'Invalid token'
        end
      end
      
      def post_data(parameters = {})
        parameters.map {|key,value| "#{key}=#{CGI.escape(value.to_s)}"}.join("&")
      end
      
      def gateway_url
        test? ? TEST_URL : LIVE_URL
      end
      
    end
  end
end

