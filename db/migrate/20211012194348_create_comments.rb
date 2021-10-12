class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :post_info, null: false, foreign_key: true
      t.string :reply

      t.timestamps
    end
  end
end
