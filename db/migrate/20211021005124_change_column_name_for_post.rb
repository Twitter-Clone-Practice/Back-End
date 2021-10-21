class ChangeColumnNameForPost < ActiveRecord::Migration[6.1]
  def change
    rename_column :posts, :number_of_replys, :number_of_comments
  end
end
