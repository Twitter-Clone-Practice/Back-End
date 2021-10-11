class CreatePostInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :post_infos do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :liked, default: false
      t.string :reply

      t.timestamps
    end
  end
end
