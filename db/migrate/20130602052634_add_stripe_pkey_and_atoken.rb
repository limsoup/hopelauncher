class AddStripePkeyAndAtoken < ActiveRecord::Migration
  def change
  	add_column :users, :stripe_connect_publishable_key, :string
  	add_column :users, :stripe_connect_authorization_token, :string
  end
end
