class AddNameToGalleryImage < ActiveRecord::Migration
  def change
    add_column :gallery_images, :name, :string
  end
end
