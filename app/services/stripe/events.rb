# frozen_string_literal: true

module Stripe
  class Events
    attr_reader :event

    def initialize(event:)
      @event = event
    end

    def call
      return unless event

      event_type = event.type
      subscription_data = event.data['object']

      case event_type
      when 'customer.subscription.created'
        handle_subscription_created(subscription_data: subscription_data)
      when 'invoice.paid'
        handle_invoice_payment_succeeded(subscription_data: subscription_data)
      when 'customer.subscription.deleted'
        handle_subscription_deleted(subscription_data: subscription_data)
      else
        Rails.logger.info "Unhandled event type: #{event_type}"
      end
    end

    private

    def handle_subscription_created(subscription_data:)
      return if ::Subscription.exists?(stripe_id: subscription_data.id)

      ::Subscription.create!(
        stripe_id: subscription_data.id,
        status: 'unpaid',
        data: subscription_data
      )
    end

    def handle_invoice_payment_succeeded(subscription_data:)
      subscription = ::Subscription.find_by(stripe_id: subscription_data.subscription)
      return unless subscription

      # Checking if the status is already 'paid'
      return if subscription.paid?

      Subscriptions::Status.pay!(subscription: subscription, subscription_data: subscription_data)
    end

    def handle_subscription_deleted(subscription_data:)
      subscription = ::Subscription.find_by(stripe_id: subscription_data.id)
      return unless subscription

      # Checking if the status is already 'canceled'
      return if subscription.canceled?

      Subscriptions::Status.cancel!(subscription: subscription, subscription_data: subscription_data)
    end
  end
end
