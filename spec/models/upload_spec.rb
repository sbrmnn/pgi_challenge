require 'rails_helper'

RSpec.describe Upload, type: :model do

  let(:upload_new) { Upload.new }
  let(:upload_create) { FactoryGirl.create(:upload) }

  it "should be valid" do
    expect(upload_create.valid?).to be true
  end

  it "must not be valid if none of the fields are filled in" do
    expect(!upload_new.valid?).to be true
  end

  it "must not be valid if the latitude field is not filled in" do
    upload_new.longitude =  -88
    upload_new.city = "Atlanta"
    upload_new.state = "Ga"
    expect(!upload_new.valid?).to be true
    expect(upload_new.errors.messages[:latitude].present?).to be true
  end

  it "must not be valid if the longitude field is not filled in" do
    upload_new.latitude =  -88
    upload_new.city = "Atlanta"
    upload_new.state = "Ga"
    expect(!upload_new.valid?)
    expect(upload_new.errors.messages[:longitude].present?).to be true
  end

  it "must not be valid if the city field is not filled in" do
    upload_new.latitude =  -88
    upload_new.longitude =  -88
    upload_new.state = "Ga"
    assert(!upload_new.valid?)
    assert(upload_new.errors.messages[:city].present?)
  end

  it "must not be valid if the state field is not filled in" do
    upload_new.latitude =  -88
    upload_new.longitude =  -88
    upload_new.city = "Atlanta"
    expect(!upload_new.valid?).to be true
    expect(upload_new.errors.messages[:state].present?).to be true
  end

  describe "test import method" do

    describe "successful imports" do
      before(:each) do
        @file_name = "convertcsv_small.csv"
        @file_path = "#{Rails.root}/spec/support/#{@file_name}"
        @file_path_cpy = "#{Rails.root}/spec/"
        FileUtils.cp(@file_path,  @file_path_cpy)
      end
      it "should import with good csv" do
        upload_error = Upload.import_csv(@file_path_cpy + @file_name)
        expect(upload_error.blank?).to be true
      end

      it "should delete file after import" do
        Upload.import_csv(@file_path_cpy + @file_name)
        expect(!File.exist?(@file_path_cpy + @file_name)).to be true
      end
    end

    describe "un successful imports" do
      before(:each) do
        @file_name = "convertcsv_small_error.csv"
        @file_path = "#{Rails.root}/spec/support/#{@file_name}"
        @file_path_cpy = "#{Rails.root}/spec/"
        FileUtils.cp(@file_path,  @file_path_cpy)
      end
      it "shouldn't import with error csv" do
        upload_error = Upload.import_csv(@file_path_cpy + @file_name)
        expect(upload_error.present?).to be true
      end

      it "should delete file after import" do
        Upload.import_csv(@file_path_cpy + @file_name)
        expect(!File.exist?(@file_path_cpy + @file_name)).to be true
      end
    end


  end
end
