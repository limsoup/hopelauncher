class RemoveTermsOfServiceFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :terms_of_service
  end
end
