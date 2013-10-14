class AddDeliveryToRewardsAndToDonation < ActiveRecord::Migration
  def change
  	add_column :donations, :delivery_address, :string
  	add_column :rewards, :delivery, :string, default: "none"
  end
end
