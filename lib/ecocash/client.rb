module Ecocash
  class Client
    include HTTParty

    def charge_subscriber(msisdn, amount)
      url = "#{Ecocash.configuration.api_base_url}/transactions/amount"
      auth = {username: "#{Ecocash.configuration.username}", password: "#{Ecocash.configuration.password}"}
      args = {
        :clientCorrelator => "#{generated_client_correlator}",
        :notifyUrl => "#{Ecocash.configuration.notify_url}",
        :referenceCode => "#{Ecocash.configuration.reference_code}",
        :tranType => "MER",
        :endUserId => "#{msisdn}",
        :remarks => "#{Ecocash.configuration.remarks}",
        :transactionOperationStatus => 'CHARGED',
        :paymentAmount => {
           :charginginformation => {
              :amount => "#{amount}",
              :currency => "#{Ecocash.configuration.currency_code}",
              :description => "#{Ecocash.configuration.description}"
           },
           :chargeMetaData => {
             :channel => "#{Ecocash.configuration.channel}",
              :purchaseCategoryCode => "#{Ecocash.configuration.purchase_category_code}",
              :onBeHalfOf => "#{Ecocash.configuration.on_behalf_of}"
           }
        },
        :merchantCode => "#{Ecocash.configuration.merchant_code}",
        :merchantPin => "#{Ecocash.configuration.merchant_pin}",
        :merchantNumber => "#{Ecocash.configuration.merchant_number}",
        :currencyCode => "#{Ecocash.configuration.currency_code}",
        :countryCode => "#{Ecocash.configuration.country_code}",
        :terminalID => "#{Ecocash.configuration.terminal_id}",
        :location => "#{Ecocash.configuration.location}",
        :superMerchantName => "#{Ecocash.configuration.super_merchant_name}",
        :merchantName => "#{Ecocash.configuration.merchant_name}"
        }.to_json

       options = {
        :body => args,
        :basic_auth => auth,
        :headers => {'Content-Type' => 'application/json'}
       }
       response = self.class.post(url, options)
       JSON.parse(response.body)
    end

    private

    def generated_client_correlator
      Time.zone.now.strftime("GD%d%m%Y%H%M%S%L%3N")
    end
  end
end