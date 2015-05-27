class Upload < ActiveRecord::Base
  attr_accessor :file
  validates_presence_of :city, :state
  validates_numericality_of :latitude, greater_than_or_equal_to:  -90, less_than_or_equal_to:  90
  validates_numericality_of :longitude, greater_than_or_equal_to: -180, less_than_or_equal_to: 180

  def self.import_csv(file_path)
    failed = []
    begin
      SmarterCSV.process(file_path,{:chunk_size => 500}) do |chunk|
        uploads = []
        uploads = chunk.map{|r| Upload.new(r)}
        failed << Upload.import(uploads, :validate => true).failed_instances
      end
   ensure
     File.delete(file_path) if File.exist?(file_path)
   end
     return failed.flatten!
  end
end
