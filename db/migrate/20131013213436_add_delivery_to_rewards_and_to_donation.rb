class AddDeliveryToRewardsAndToDonation < ActiveRecord::Migration
  def change
  	add_column :donations, :delivery_address, :hash
  	add_column :rewards, :delivery, :string, default: "none"
  end
end
