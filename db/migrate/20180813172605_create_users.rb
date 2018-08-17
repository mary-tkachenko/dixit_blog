class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :username
      t.string :password
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
