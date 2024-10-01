# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscription) { build(:subscription) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subscription).to be_valid
    end

    it 'is not valid without a stripe_id' do
      subscription.stripe_id = nil
      expect(subscription).to_not be_valid
    end

    it 'is not valid without a status' do
      subscription.status = nil
      expect(subscription).to_not be_valid
    end

    it 'is not valid with a duplicate stripe_id' do
      create(:subscription, stripe_id: 'sub_123')
      subscription.stripe_id = 'sub_123'
      expect(subscription).to_not be_valid
    end

    it 'is not valid with an invalid status' do
      expect {
        subscription.status = 'invalid_status'
      }.to raise_error(ArgumentError, "'invalid_status' is not a valid status")
    end
  end

  context 'default values' do
    it 'has a default status of unpaid' do
      subscription.save!
      expect(subscription.status).to eq('unpaid')
    end
  end

  context 'status transitions' do
    before { subscription.save! }

    it 'can transition from unpaid to paid' do
      Subscriptions::Status.pay!(subscription: subscription)
      expect(subscription.status).to eq('paid')
    end

    it 'can transition from paid to canceled' do
      Subscriptions::Status.pay!(subscription: subscription)
      Subscriptions::Status.cancel!(subscription: subscription)
      expect(subscription.status).to eq('canceled')
    end

    it 'cannot transition from unpaid to canceled' do
      Subscriptions::Status.cancel!(subscription: subscription)
      expect(subscription.errors[:status]).to include('can only transition to canceled from paid')
    end
  end
end
