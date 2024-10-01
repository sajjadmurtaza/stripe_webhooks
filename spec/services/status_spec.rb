# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscriptions::Status, type: :service do
  let(:subscription) { create(:subscription, status: 'unpaid') }
  let(:subscription_data) { { "id" => "sub_123", "object" => "subscription", "status" => "active" } }

  describe '.pay!' do
    it 'updates the subscription status to paid' do
      Subscriptions::Status.pay!(subscription: subscription, subscription_data: subscription_data)
      expect(subscription.reload.status).to eq('paid')
    end

    it 'updates the subscription data' do
      Subscriptions::Status.pay!(subscription: subscription, subscription_data: subscription_data)
      expect(subscription.reload.data).to eq(subscription_data)
    end
  end

  describe '.cancel!' do
    before { subscription.update!(status: 'paid') }

    it 'updates the subscription status to canceled' do
      Subscriptions::Status.cancel!(subscription: subscription, subscription_data: subscription_data)
      expect(subscription.reload.status).to eq('canceled')
    end

    it 'updates the subscription data' do
      Subscriptions::Status.cancel!(subscription: subscription, subscription_data: subscription_data)
      expect(subscription.reload.data).to eq(subscription_data)
    end
  end
end
