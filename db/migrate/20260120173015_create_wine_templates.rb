class CreateWineTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :wine_templates do |t|
      t.string :name
      t.string :wine_type
      t.string :region
      t.decimal :price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
