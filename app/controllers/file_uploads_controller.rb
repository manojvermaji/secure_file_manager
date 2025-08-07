class FileUploadsController < ApplicationController
  before_action :authenticate_user!, except: [:public_view]
  before_action :set_file, only: [:destroy, :download, :public_view]

  def index
    @file_uploads = current_user.file_uploads
  end

  def new
    @file_upload = current_user.file_uploads.build
  end

	def create
		@file_upload = current_user.file_uploads.new(file_params)

		if @file_upload.save
			redirect_to file_uploads_path, notice: "File uploaded successfully."
		else
			flash.now[:alert] = "Failed to upload file."
			render :new, status: :unprocessable_entity
		end
	end

  def destroy
    @file_upload.destroy
    redirect_to file_uploads_path, notice: "File deleted."
  end

  def public_view
    if @file_upload.public?
      send_file @file_upload.file.blob.service.send(:path_for, @file_upload.file.key), disposition: 'attachment'
    else
      render plain: "Unauthorized", status: :unauthorized
    end
  end

  def download
    if @file_upload.user == current_user
      send_file @file_upload.file.blob.service.send(:path_for, @file_upload.file.key), disposition: 'attachment'
    else
      render plain: "Unauthorized", status: :unauthorized
    end
  end

  private
	def set_file
		if params[:share_token]
		  @file_upload = FileUpload.find_by(share_token: params[:share_token])
		else
		  @file_upload = FileUpload.find_by(id: params[:id])
		end
	end


  def file_params
    params.require(:file_upload).permit(:title, :description, :file).merge(public: false)
  end

  def compress_if_needed(file_upload)
    return unless file_upload.file.byte_size > 5.megabytes

    # OPTIONAL: implement compression here using MiniMagick or external tools
    # For now, just log file info
    Rails.logger.info "File #{file_upload.title} is #{file_upload.file.byte_size} bytes (type: #{file_upload.file_type})"
  end
end
