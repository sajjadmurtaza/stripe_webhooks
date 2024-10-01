class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.string :stripe_id, null: false
      t.string :status, null: false, default: 'unpaid'
      t.jsonb :data, default: {}

      t.timestamps
    end

    add_index :subscriptions, :stripe_id, unique: true
  end
end
