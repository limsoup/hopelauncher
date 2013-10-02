class AddStripeHashToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :stripe_hash, :text
    add_column :donations, :charge_successful, :boolean
  end
end
