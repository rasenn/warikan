class CreateWhos < ActiveRecord::Migration
  def change
    create_table :whos do |t|
      t.references :kingaku, index: true
      t.references :member, index: true

      t.timestamps null: false
    end

    add_foreign_key :whos, :kingaku
    add_foreign_key :whos, :member
  end
end
