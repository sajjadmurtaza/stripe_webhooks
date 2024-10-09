# frozen_string_literal: true

module Webhooks
  class StripeController < ApplicationController
    def create
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, ENV.fetch('STRIPE_WEBHOOK_SECRET', nil), tolerance: ENV.fetch('TOLERANCE', 500).to_i
        )
      rescue JSON::ParserError, Stripe::SignatureVerificationError
        head :bad_request
        return
      end

      StripeEventJob.perform_later(event: event.to_json)

      head :ok
    end
  end
end
