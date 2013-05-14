class BlocksController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :block, :through => :project
  # load_and_authorize_resource #:except => [:new]

  def new
  	# @project = Project.find(params[:project_id])
  	# @block = @project.blocks.new
  	# @project = @block.project
  end

  def create
		respond_to do |format|
      if @block.save(params[:block])
        format.html { redirect_to @project, notice: 'Block was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
		respond_to do |format|
      if @block.update_attributes(params[:block])
        format.html { redirect_to @project, notice: 'Block was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

end
