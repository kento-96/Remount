class CreateMountains < ActiveRecord::Migration[5.2]
  def change
    create_table :mountains do |t|

      t.integer :user_id
      t.string :mountain_name
      t.text :mountain_body
      t.string :address
      t.string :mountain_image_id
      t.float :laitude
      t.float :longitude

      t.timestamps
    end
  end
end
