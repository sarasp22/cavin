class AddUserToWines < ActiveRecord::Migration[7.0]
  def change
    # 1. Aggiungiamo la colonna permettendo temporaneamente valori NULL
    add_reference :wines, :user, null: true, foreign_key: true

    # 2. Colleghiamo i vini esistenti al proprietario del loro storage
    #    (Eseguiamo questo solo se ci sono dati)
    up_only do
      execute <<-SQL
        UPDATE wines
        SET user_id = storages.user_id
        FROM storages
        WHERE wines.storage_id = storages.id
      SQL

      # Per i vini che hanno lo storage già eliminato,
      # li assegniamo al primo utente (o puoi lasciarli NULL se preferisci)
      # execute "UPDATE wines SET user_id = (SELECT id FROM users LIMIT 1) WHERE user_id IS NULL"
    end

    # 3. Ora che tutti hanno un user_id, rendiamo la colonna NOT NULL
    # change_column_null :wines, :user_id, false
  end
end
