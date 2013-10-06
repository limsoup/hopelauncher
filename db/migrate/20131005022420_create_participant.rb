class CreateParticipant < ActiveRecord::Migration
  def change
    create_table :project_participants do |t|
		t.string :first_name
		t.string :last_name
		t.integer :project_id
      	t.timestamps
    end

    add_column :donations, :project_participant_id, :integer
  end
end
