class AddSubmitForReviewToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :under_review, :boolean
  end
end
