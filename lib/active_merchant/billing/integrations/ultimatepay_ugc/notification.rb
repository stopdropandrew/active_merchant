require 'net/http'

module ActiveMerchant::Billing::Integrations
  module UltimatepayUgc
    class Notification < ActiveMerchant::Billing::Integrations::Notification
      def response(fail_reason = nil)
        [
          (valid? && !fail_reason) ? '[OK]' : '[ERROR]',
          Time.now.strftime('%Y%m%d%H%M%S'),
          '',
          fail_reason || reponse_text
        ].join('|')
      end

      def reponse_text
        if !valid_login?
          "Invalid_Login"
        elsif !valid_hash?
          "Invalid_Hash"
        elsif !valid_commtype?
          "Internal_Error"
        else
          "[N/A]"
        end
      end

      def valid?
        valid_login? && valid_hash? && valid_commtype?
      end
      alias acknowledge valid?

      def valid_commtype?
        "PAYMENT" == params['commtype']
      end

      def valid_hash?
        params['hash'] == generate_hash_from_request(params)
      end

      def valid_login?
        @options[:gateway].valid_login?(params['login'], params['adminpwd'])
      end

      def user_id
        params['userid'].to_i
      end

      def transaction_id
        params['pbctrans']
      end

      def username
        params['accountname']
      end

      def amount
        params['sepamount'].to_f
      end

      def currency
        params['currency']
      end

      def received_at
        time = params['dtdatetime']
        year = time[0..3]
        month = time[4..5]
        day = time[6..7]
        hour = time[8..9]
        min = time[10..11]
        sec = time[12..13]

        time_string = "%s/%s/%s %s:%s:%s" % [month, day, year, hour, min, sec]
        Time.parse(time_string)
      end
      
      def generate_hash_from_request(request)
        hash = Digest::MD5.hexdigest(s = [
          request['dtdatetime'],
          request['login'],
          request['adminpwd'],
          @options[:gateway].secret_phrase,
          request['userid'],
          request['commtype'],
          request['set_amount'],
          request['amount'],
          request['sepamount'],
          request['currency'],
          request['sn'],
          request['mirror'],
          CGI.unescape(request['pbctrans'].to_s),
          request['developerid'],
          request['appid']
        ].join)
      end
    end
  end
end