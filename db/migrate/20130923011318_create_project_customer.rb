class CreateProjectCustomer < ActiveRecord::Migration
  def change
    create_table :project_customers do |t|
		t.integer :project_id
		t.integer :user_id
		t.string :stripe_customer_id
      	t.timestamps
    end

    add_column :donations, :stripe_card_id, :string
  end
end
