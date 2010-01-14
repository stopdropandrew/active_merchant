require 'net/http'
require 'digest/sha1'
require 'base64'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Zong
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          ZONG_PUBLIC_KEY = <<-END_KEY
          -----BEGIN PUBLIC KEY-----
          MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCt8WGFD2HH1sHbdtrZ0MspHueV
          Db2vjk2G11qLoxZiTehfRTmlKivFMkdC/4PMtF73Z4kjHDr+7lU9b4DmkcNyZ03D
          srRtudY9cGWh0cYCCsODjScjSCKpfTPUj/3Rxe6hcqhfIWw3XuduaALBnT31NR49
          9Qodp859RnBpuwSieQIDAQAB
          -----END PUBLIC KEY-----    
          END_KEY

          def transaction_ref
            params['transactionRef']
          end

          def item_ref
            params['itemRef']
          end

          def status
            params['status'] # COMPLETED or FAILED
          end

          def complete?
            'COMPLETED' == status
          end 

          # Failure causes for a FAILED transaction 
          # EXPIRED The transaction was never completed within a 24 hour time period from start of transaction. i.e. abandoned
          # CANCELED Mobile consumer cancelled the transaction
          # CREDIT Mobile consumer does not have enough credit for this transaction
          # BARRED Mobile consumer has been barred by his carrier
          # TARIF Tarif not supported by mobile consumers carrier
          # UNKNOWN Unclassified errors
          def failure
            params['failure']   
          end

          def payment_method
            params['method']    # MOBILE, CC, POINTS
          end

          def msisdn
            params['msisdn']    # aka phone number
          end

          def out_payment
            params['outPayment']
          end

          # Was this a test transaction?
          def test?
            'true' == params['simulated']
          end

          def signature
            params['signature']
          end

          def signature_version
            params['signatureVersion']
          end

          # zong doesn't do an http post to verify; just check signature
          # The signature is calculated in the following way:
          # 1.  We take the query string including the leading “?” symbol
          # 2.  The parameter signature= (the value is empty) is appended to the query string
          # 3.  The parameter signatureVersion=1 is appended to the query string
          # 4.  The parameters are ordered alphabetically by name and value
          # 5.  The signature is generated using SHA1 with RSA
          # 6.  The generated value is coded in BASE64 and added in place of the empty value of the signature parameter
          def valid_signature?
            decoded_signature = Base64.decode64(signature)
            OpenSSL::PKey::RSA.new(ZONG_PUBLIC_KEY).verify(OpenSSL::Digest::SHA1.new, decoded_signature, signature_string)
          end
          alias acknowledge valid_signature?

          def signature_string
            querystring = "?signature=&signatureVersion=1&"
            querystring << params.to_a.reject{|a| a[0].match(/^signature/)}.sort_by(&:first).map{|key, value| "#{key}=#{CGI.escape(value.to_s)}"}.join("&")
          end

          # response string to send to Zong
          def response
            valid_signature? ? "#{transaction_ref}:OK" : 'INVALID'
          end
        end
      end
    end
  end
end