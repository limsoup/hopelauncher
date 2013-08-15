class GalleryImagesController < ApplicationController
	def create
		@project = Project.find(params[:project_id])

		if(params[:files])
			logger.ap params
			@gallery_image = @project.gallery_images.create(:image => params[:files].first)
			@gallery_image.save
			# @project_image = ProjectImage.create(params[:project_image])
			gallery = {:files => []}
			# @project.gallery_images.each do |gi|
			gallery_image_object = {}
			gallery_image_object[:name] = @gallery_image.name
			gallery_image_object[:size] = @gallery_image.image.size
			gallery_image_object[:url] = @gallery_image.image_url
			gallery_image_object[:thumb] = @gallery_image.image_url(:thumb)
			gallery_image_object[:thumbnailUrl] = @gallery_image.image_url(:thumb)
			gallery_image_object[:deleteUrl] = project_gallery_image_path(@project.id, @gallery_image.id)
			gallery_image_object[:deleteType] = "DELETE"
			gallery_image_object[:index] = @project.gallery_images.count-1
			logger.ap gallery_image_object
			gallery[:files] << gallery_image_object
		end
		render :json => gallery
	end

	def index
		@project = Project.find(params[:project_id])
		gallery = {:files => []}
		@project.gallery_images.each do |gi|
			gallery_image_object = {}
			gallery_image_object[:name] = gi.name
			gallery_image_object[:size] = gi.image.size
			gallery_image_object[:url] = gi.image_url
			gallery_image_object[:thumb] = gi.image_url(:thumb)
			gallery_image_object[:thumbnailUrl] = gi.image_url(:thumb)
			gallery_image_object[:deleteUrl] = project_gallery_image_path(@project.id, gi.id)
			gallery_image_object[:deleteType] = "DELETE"
			gallery[:files] << gallery_image_object
		end
		logger.ap gallery
		render :json => gallery
	end

	def destroy
		@project = Project.find(params[:project_id])
		@gallery_image = @project.gallery_images.find(params[:id])
		@gallery_image.destroy
		render :nothing => true
	end

	def show
		@project = Project.find(params[:project_id])
		@gallery_image = @project.gallery_images.find(params[:id])
	end
end