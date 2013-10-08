class ChangeTermsOfService < ActiveRecord::Migration
  def change
  	rename_column :users, :tos_accept, :terms_of_service
  end
end
