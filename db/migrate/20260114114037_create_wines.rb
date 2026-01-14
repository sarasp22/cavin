class CreateWines < ActiveRecord::Migration[7.1]
  def change
    create_table :wines do |t|
      t.string :name
      t.string :wine_type
      t.string :region
      t.decimal :price
      t.integer :row_position
      t.integer :col_position
      t.datetime :consumed_at
      t.references :storage, null: false, foreign_key: true

      t.timestamps
    end
  end
end
