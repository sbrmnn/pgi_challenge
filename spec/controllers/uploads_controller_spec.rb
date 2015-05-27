require 'rails_helper'

RSpec.describe UploadsController, type: :controller do

  describe "GET index" do
    it "assigns @upload" do
      get :new
      expect(assigns(:upload).persisted?).to eq(false)
    end
  end


  describe "POST create" do
    before(:each) do
      @file_name = "convertcsv_small_error.csv"
      @file_path = "#{Rails.root}/spec/support/#{@file_name}"
      @file_path_cpy = "#{Rails.root}/spec/"
      FileUtils.cp(@file_path,  @file_path_cpy)
    end
    it "shouldn't upload with error csv" do
      post :create, upload: {file: ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(@file_path_cpy + @file_name), :filename => File.basename(@file_path_cpy + @file_name))}
      expect(assigns(:upload_errors).present?).to eq(true)
      expect(response).to render_template(:new)
    end

    it "should upload with good csv" do
      post :create, upload: {file: ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(@file_path_cpy + @file_name), :filename => File.basename(@file_path_cpy + @file_name))}
      expect(assigns(:upload_errors).present?).to eq(true)
      expect(response).to render_template(:new)
    end

  end

end
