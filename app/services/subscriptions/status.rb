# frozen_string_literal: true

module Subscriptions
  class Status
    def self.pay!(subscription:, subscription_data: {})
      subscription.update!(status: 'paid', data: subscription_data)
    end

    def self.cancel!(subscription:, subscription_data: {})
      subscription.update!(status: 'canceled', data: subscription_data)
    end
  end
end
