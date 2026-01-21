class ChangeStorageIdInWinesToNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :wines, :storage_id, true
  end
end
