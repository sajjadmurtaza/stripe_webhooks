class StripeEventJob < ApplicationJob
  queue_as :default

  def perform(event:)
    event = Stripe::Event.construct_from(JSON.parse(event))
    ::Stripe::Events.new(event: event).call
  end
end
