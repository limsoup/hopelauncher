class GalleryImage < ActiveRecord::Base
	belongs_to :project
	attr_accessible :image, :remote_image_url, :name

	mount_uploader :image, ImageUploader
end