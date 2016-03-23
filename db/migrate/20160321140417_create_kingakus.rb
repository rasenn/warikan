class CreateKingakus < ActiveRecord::Migration
  def change
    create_table :kingakus do |t|
      t.integer :kingaku
      t.text :memo
      t.datetime :created_at

      t.references :member, index: true
      t.references :list, index:true
      
      t.timestamps null: false
    end

    add_foreign_key :kingakus, :members
    add_foreign_key :kingakus, :lists
  end
end
