class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.references :list, index: true 
      
      t.timestamps null: false
    end
    add_foreign_key :members, :lists
  end
end
