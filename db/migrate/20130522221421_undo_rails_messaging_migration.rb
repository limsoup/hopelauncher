class UndoRailsMessagingMigration < ActiveRecord::Migration
  def change
		drop_table :messaging_users
		drop_table :notifications
		drop_table :receipts
		drop_table :conversations
  end
end
