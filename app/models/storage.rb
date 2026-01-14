class Storage < ApplicationRecord
  belongs_to :user
  has_many :wines, dependent: :destroy

  CATEGORIES = ["Cave", "Vinothèque cuisine", "Vinothèque salon", "Meuble cuisine"]

  validates :name, :category, :rows, :cols, presence: true
end
