class AddMiddleNameToProjectParticipants < ActiveRecord::Migration
  def change
    add_column :project_participants, :middle_name, :string
  end
end
