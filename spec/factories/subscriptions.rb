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
FactoryBot.define do
  factory :subscription do
    stripe_id { "sub_#{SecureRandom.hex(8)}" }
    status { 'unpaid' }
    data { {} }
  end
end
