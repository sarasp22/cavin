class AddNotesToWines < ActiveRecord::Migration[7.1]
  def change
    add_column :wines, :notes, :text
  end
end
