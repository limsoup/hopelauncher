class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
		t.integer :project_id
		t.string :description
		t.integer :donation_amount
      	t.timestamps
    end

    add_column :donations, :reward_id, :integer
  end
end
