module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class UltimatepayUgcGateway < Gateway
      # we'll use the live url for tests until they get a real test gateway
      TEST_URL = 'https://www.ultimatepay.com/app/api/live/'
      LIVE_URL = 'https://www.ultimatepay.com/app/api/live/'
      
      self.default_currency = 'USD'
      
      # The homepage URL of the gateway
      self.homepage_url = 'http://www.ultimatepay.com/'
      
      # The name of the gateway
      self.display_name = 'Ultimatepay UGC Gateway'
      
      def initialize(options = {})
        requires!(options, :merchant_code, :password, :secret_phrase)
        @options = options
        super
      end 
      
      def purchase(money, options = {})
        post = {}
        add_boilerplate_info(post, money)
        add_ugc_pin(post, options)
        add_customer_data(post, options)
        add_hash(post)

        commit(post)
      end

      private
      
      def add_boilerplate_info(post, money)
        post[:amount] = money
        post[:currency] = currency(money)

        post[:sn] = options[:merchant_code]
        post[:paymentid] = 'UG'
        post[:method] = 'StartOrderDirect'
      end
      
      def add_ugc_pin(post, options)
        post[:ugc_pin] = options[:ugc_pin]
      end
      
      def add_customer_data(post, options)
        post[:userid] = options[:user_id]
      end
      
      def add_hash(post)
        hash = Digest::MD5.hexdigest(s = [
          post[:userid],
          @options[:password],
          @options[:secret_phrase],
          post[:currency],
          post[:amount],
          post[:paymentid]
        ].join)
        post[:hash] = hash
      end
      
      def commit(parameters)
        response = parse( ssl_post(gateway_url, post_data(parameters) ) )
        
        Response.new(response["result"] == "paid", message_from(response['errorDetail']), response, 
          :authorization => response["pbctrans"],
          :test => test?
        )
      end

      def parse(body)
        results = {}
        body.split('&').each do |pair|
          key,val = pair.split('=')
          results[key] = val
        end
        
        results
      end     
      
      def message_from(response)
        case response
        when 'ugc_pin'
          'Invalid pin'
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

