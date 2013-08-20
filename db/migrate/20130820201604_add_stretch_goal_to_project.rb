class AddStretchGoalToProject < ActiveRecord::Migration
  def change
    add_column :projects, :stretch_goals, :text
  end
end
