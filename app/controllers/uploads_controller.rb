class UploadsController < ApplicationController
  def new
    @upload = Upload.new
  end

  def create
    @upload_errors = []
    if params[:upload][:file]
      file = Tempfile.new("smarter_csv.csv")
      file.write(params[:upload][:file].read)
      file.close
      @upload_errors = Upload.import_csv(file.path)
    else
      upload = Upload.new(upload_params)
      unless upload.save
        @upload_errors << upload
      end
    end
    
    respond_to do |format|
      if @upload_errors.present?
        format.html {render :new}
        format.js {render nothing: true, status: 422}
      else
        format.html {redirect_to action: :new}
        format.js {render nothing: true, status: 200}
      end
    end
  end

  private

  def upload_params
    params.require(:upload).permit(:city, :state, :longitude, :latitude)
  end
end
