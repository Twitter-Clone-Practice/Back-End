class RemoveReplyFromPostInfos < ActiveRecord::Migration[6.1]
  def change
    remove_column :post_infos, :reply
  end
end
