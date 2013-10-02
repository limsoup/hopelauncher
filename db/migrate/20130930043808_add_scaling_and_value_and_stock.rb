class AddScalingAndValueAndStock < ActiveRecord::Migration
  def change
  	add_column :rewards, :scale, :boolean, :default => false
  	add_column :rewards, :value, :integer
  	add_column :rewards, :stock, :integer
  end
end
