class AddCreatorAndProjectInfo < ActiveRecord::Migration
  def change
  	add_column :projects, :goal, :integer

		add_column :users, :legal_name, :string
		add_column :users, :statement_name, :string
		add_column :users, :statement_number, :string
		add_column :users, :ein, :integer
		add_column :users, :first_name, :string
		add_column :users, :last_name, :string
		add_column :users, :date_of_birth, :integer

		add_column :users, :street, :string
		add_column :users, :zip, :int
		add_column :users, :city, :string
		add_column :users, :state, :string
		add_column :users, :country, :string
  end
end
