class AddSizeToWines < ActiveRecord::Migration[7.1]
  def change
    add_column :wines, :size, :string
  end
end
