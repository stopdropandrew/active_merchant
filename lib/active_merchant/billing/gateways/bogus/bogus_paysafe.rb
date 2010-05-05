module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class BogusPaysafeGateway < PaysafeGateway
      GUID_CREATED = 'created-guid'
      GUID_DISPOSED = 'disposed-guid'
      GUID_EXPIRED = 'expired-guid'
      
      def authorize(options = {})
        requires!(options, :transaction_id, :amount, :ok_url, :nok_url)
        
        Response.new(true, '', {}, :test => true )
      end
      
      def check_transaction_status(options = {})
        requires!(options, :transaction_id)
        
        case options[:transaction_id]
        when GUID_CREATED
          Response.new(true, '', { 'TransactionState' => PaysafeGateway::DISPOSITION_CREATED }, :test => true)
        when GUID_DISPOSED
          Response.new(true, '', { 'TransactionState' => PaysafeGateway::DISPOSITION_DISPOSED }, :test => true)
        when GUID_EXPIRED
          Response.new(true, '', { 'TransactionState' => PaysafeGateway::DISPOSITION_EXPIRED }, :test => true)
        end
      end
      
      def capture(options = {})
        requires!(options, :transaction_id, :amount)

        Response.new(true, '', {}, :test => true )
      end
    end
  end
end
