class GalleryImagesController < ApplicationController
	def create
		@project = Project.find(params[:project_id])
		if(params[:gallery_image])
			@gallery_image = @project.gallery_images.create(:image => params[:gallery_image][:image].first)
			@gallery_image.save
			# @project_image = ProjectImage.create(params[:project_image])
			# gallery = {:files => []}
			# @project.gallery_images.each do |gi|
			gallery_image_object = {}
			gallery_image_object[:name] = @gallery_image.image.filename
			gallery_image_object[:size] = @gallery_image.image.size
			gallery_image_object[:url] = @gallery_image.image_url
			gallery_image_object[:thumb] = @gallery_image.image_url(:thumb)
			gallery_image_object[:delete_url] = project_gallery_image_path(@project.id, @gallery_image.id)
			gallery_image_object[:delete_type] = "DELETE"
			gallery_image_object[:index] = @project.gallery_images.count-1
			logger.ap gallery_image_object
			# gallery[:files] << gallery_image_object
		end
		render :json => gallery_image_object
	end

	def index
		@project = Project.find(params[:project_id])
		gallery = {:files => []}
		@project.gallery_images.each do |gi|
			gallery_image_object = {}
			gallery_image_object[:name] = gi.image.filename
			gallery_image_object[:size] = gi.image.size
			gallery_image_object[:url] = gi.image_url
			gallery_image_object[:thumb] = gi.image_url(:thumb)
			gallery_image_object[:delete_url] = project_gallery_image_path(@project.id, gi.id)
			gallery_image_object[:delete_type] = "DELETE"
			gallery[:files] << gallery_image_object
		end
		render :json => gallery
	end

	def destroy
		@project = Project.find(params[:project_id])
		@gallery_image = @project.gallery_images.find(params[:id])
		@gallery_images.destroy
	end

	def show
		@project = Project.find(params[:project_id])
		@gallery_image = @project.gallery_images.find(params[:id])
	end
end