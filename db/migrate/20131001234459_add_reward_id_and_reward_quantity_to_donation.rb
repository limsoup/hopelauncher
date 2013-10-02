class AddRewardIdAndRewardQuantityToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :reward_quantity, :integer
  end
end
