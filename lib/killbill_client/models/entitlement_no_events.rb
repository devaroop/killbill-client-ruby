module KillBillClient
  module Model
    class EntitlementNoEvents < EntitlementAttributesNoEvents

      KILLBILL_API_ENTITLEMENT_PREFIX = "#{KILLBILL_API_PREFIX}/entitlements"

      class << self
        def find_by_id(entitlement_id,  options = {})
          get "#{KILLBILL_API_ENTITLEMENT_PREFIX}/#{entitlement_id}",
              {},
              options
        end
      end

      #
      # Create a new entitlement
      #
      def create(user = nil, reason = nil, comment = nil, options = {})
        created_entitlement = self.class.post KILLBILL_API_ENTITLEMENT_PREFIX,
                                              to_json,
                                              {},
                                              {
                                                  :user => user,
                                                  :reason => reason,
                                                  :comment => comment,
                                              }.merge(options)
        created_entitlement.refresh(options)
      end

      #
      # Change the plan of the existing Entitlement
      #
      # @input : the hash with the new product info { product_name, billing_period, price_list}
      # @requested_date : the date when that change should occur
      # @billing_policy : the override for the billing policy {END_OF_TERM, IMMEDIATE}
      # @ call_completion : whether the call should wait for invoice/payment to be completed before calls return
      #
      def change_plan(input, user = nil, reason = nil, comment = nil,
           requested_date = nil, billing_policy = nil, call_completion = false,options = {})

        params = {}
        params[:callCompletion] = call_completion
        params[:requestedDate] = requested_date unless requested_date.nil?
        params[:policy] = billing_policy unless billing_policy.nil?

        return self.class.put "#{KILLBILL_API_ENTITLEMENT_PREFIX}/#{@subscription_id}",
                              input.to_json,
                              params,
                              {
                                  :user => user,
                                  :reason => reason,
                                  :comment => comment,
                              }.merge(options)
      end

      #
      # Cancel the entitlement at the requested date
      #
      # @requested_date : the date when that change should occur
      # @billing_policy : the override for the billing policy {END_OF_TERM, IMMEDIATE}
      #
      def cancel(user = nil, reason = nil, comment = nil, requested_date = nil, entitlementPolicy = nil, billing_policy = nil, options = {})

        params = {}
        params[:requestedDate] = requested_date unless requested_date.nil?
        params[:billingPolicy] = billing_policy unless billing_policy.nil?
        params[:entitlementPolicy] = entitlementPolicy unless entitlementPolicy.nil?

        return self.class.delete "#{KILLBILL_API_ENTITLEMENT_PREFIX}/#{@subscription_id}",
                              params,
                              {
                                  :user => user,
                                  :reason => reason,
                                  :comment => comment,
                              }.merge(options)
      end
    end
  end
end