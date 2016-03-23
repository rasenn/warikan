class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :url_hash, :unique => true
      t.datetime :created_at

      t.timestamps null: false
    end
  end
end
