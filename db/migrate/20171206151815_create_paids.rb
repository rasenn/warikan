class CreatePaids < ActiveRecord::Migration
  def change
    create_table :paids do |t|
      t.integer :kingaku
      t.string  :memo
      t.integer :pay_member_id, index: true, null: false
      t.integer :recieve_member_id, index: true, null: false

      t.references :list, index:true

      t.timestamps null: false
    end

    add_foreign_key :paids, :pay_member_id
    add_foreign_key :paids, :recive_member_id
    add_foreign_key :kingakus, :lists
  end
end
