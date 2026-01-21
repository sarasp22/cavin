class AddUserToWines < ActiveRecord::Migration[7.0]
  def change
    add_reference :wines, :user, null: true, foreign_key: true

    up_only do
      execute <<-SQL
        UPDATE wines
        SET user_id = storages.user_id
        FROM storages
        WHERE wines.storage_id = storages.id
      SQL


    end
  end
end
