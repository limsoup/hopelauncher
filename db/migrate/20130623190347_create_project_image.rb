class CreateProjectImage < ActiveRecord::Migration
  def change
    create_table :gallery_images do |t|
    	t.string :image
    	t.integer :project_id

    	t.timestamps
    end
  end
end
