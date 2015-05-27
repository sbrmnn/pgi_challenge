require 'rails_helper'

RSpec.describe UploadsController, type: :controller do

  describe "GET index" do
    it "assigns @upload" do
      get :new
      expect(assigns(:upload).persisted?).to eq(false)
    end
  end

  describe "POST create" do
    describe "POST create with params" do

      it "should upload with params" do
        post :create, upload: {city: "Atlanta", state: "Ga", longitude: 90, latitude: 80}
        expect(assigns(:upload).persisted?).to eq(true)
        expect(response).should redirect_to '/uploads'
      end

      it "shouldn't upload with incomplete params" do
        post :create, upload: {city: nil, state: nil, longitude: 90, latitude: 80}
        expect(assigns(:upload).persisted?).to eq(false)
      end
    end
    describe "POST create error csv" do
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
    end

    describe "POST create wrong headers csv" do
      before(:each) do
        @file_name = "test_events-2.csv"
        @file_path = "#{Rails.root}/spec/support/#{@file_name}"
        @file_path_cpy = "#{Rails.root}/spec/"
        FileUtils.cp(@file_path,  @file_path_cpy)
      end

      it "shouldn't upload with wrong headers csv" do
        post :create, upload: {file: ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(@file_path_cpy + @file_name), :filename => File.basename(@file_path_cpy + @file_name))}
        expect(assigns(:corrupt_file).present?).to eq(true)
        expect(assigns(:upload_errors).present?).to eq(false)
        expect(response).to render_template(:new)
      end
    end

    describe "POST create good csv" do

      before(:each) do
        @file_name = "convertcsv_small.csv"
        @file_path = "#{Rails.root}/spec/support/#{@file_name}"
        @file_path_cpy = "#{Rails.root}/spec/"
        FileUtils.cp(@file_path,  @file_path_cpy)
      end

      it "should upload with good csv" do
        post :create, upload: {file: ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(@file_path_cpy + @file_name), :filename => File.basename(@file_path_cpy + @file_name))}
        expect(assigns(:upload_errors).present?).to eq(false)
        response.should redirect_to '/uploads'
      end
    end
  end
end
