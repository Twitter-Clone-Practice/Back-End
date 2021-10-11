class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :message
      t.integer :number_of_likes, default: 0
      t.integer :number_of_replys, default: 0

      t.timestamps
    end
  end
end
