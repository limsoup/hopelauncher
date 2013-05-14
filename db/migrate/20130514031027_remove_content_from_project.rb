class RemoveContentFromProject < ActiveRecord::Migration
  def change
  	remove_column :projects, :content
  end
end
