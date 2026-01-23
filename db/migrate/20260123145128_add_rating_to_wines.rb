class AddRatingToWines < ActiveRecord::Migration[7.1]
  def change
    add_column :wines, :rating, :integer
  end
end
