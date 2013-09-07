class ChangeStripeAttributes < ActiveRecord::Migration
  def change
    rename_column :users, :stripe_connect_publishable_key, :stripe_publishable_key
    remove_column :users, :stripe_connect_authorization_token
    remove_column :users, :provider
    remove_column :users, :uid
  end
end
