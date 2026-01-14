class CreateStorages < ActiveRecord::Migration[7.1]
  def change
    create_table :storages do |t|
      t.string :name
      t.string :category
      t.integer :rows
      t.integer :cols
      t.string :photo_url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
