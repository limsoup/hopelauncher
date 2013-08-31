class AddAccountStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_state, :string, :default => "unapproved"
    add_column :users, :account_type, :string, :default => "member"
  end
end
