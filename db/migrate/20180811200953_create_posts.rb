class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :date
      t.string :text
      t.integer :visual_x_position
      t.integer :visual_y_position
      t.integer :visual_id
      # t.integer :user_id
    end
  end
end
