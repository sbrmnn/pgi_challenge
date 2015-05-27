class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :city, null: false
      t.string :state, null: :false
      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false

      t.timestamps null: false
    end
  end
end
