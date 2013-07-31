class AddContentToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :content, :string
  end
end
