class AddAmountAndChargeToDonation < ActiveRecord::Migration
  def change
  	add_column :donations, :stripe_charge_id, :string
  	add_column :donations, :amount, :integer
  end
end
