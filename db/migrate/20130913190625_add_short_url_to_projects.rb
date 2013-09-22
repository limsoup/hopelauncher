class AddShortUrlToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :short_path, :string
  end
end
