class ChangeContentColumnTypeInProject < ActiveRecord::Migration
  def change
  	change_column :projects, :content, :text, :limit => nil
  end
end
