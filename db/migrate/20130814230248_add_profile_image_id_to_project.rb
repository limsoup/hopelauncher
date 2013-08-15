class AddProfileImageIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :profile_image_id, :integer
  end
end
