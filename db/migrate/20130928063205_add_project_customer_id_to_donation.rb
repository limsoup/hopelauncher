class AddProjectCustomerIdToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :project_customer_id, :integer
  end
end
