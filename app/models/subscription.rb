# == Schema Information
#
# Table name: subscriptions
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  status     :string           default("unpaid"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stripe_id  :string           not null
#
# Indexes
#
#  index_subscriptions_on_stripe_id  (stripe_id) UNIQUE
#
class Subscription < ApplicationRecord
  enum :status, { unpaid: 'unpaid', paid: 'paid', canceled: 'canceled' }

  validates :stripe_id, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: statuses.keys }

  before_update :validate_status_transition

  private

  def validate_status_transition
    return unless status_changed? && status == 'canceled' && status_was != 'paid'

    errors.add(:status, 'can only transition to canceled from paid')
  end
end
