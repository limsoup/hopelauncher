class AddTosAcceptTosUsers < ActiveRecord::Migration
  def change
  	add_column :users, :tos_accept, :boolean
  end
end
