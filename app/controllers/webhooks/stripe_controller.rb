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
      rescue JSON::ParserError => e
        render json: { error: 'Invalid payload' }, status: :bad_request
        return
      rescue Stripe::SignatureVerificationError => e
        render json: { error: 'Invalid signature' }, status: :bad_request
        return
      end

      Stripe::Events.new(event:).call

      render json: { message: 'success' }
    end
  end
end
