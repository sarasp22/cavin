class WineTemplate < ApplicationRecord
  belongs_to :user

  validates :name, :wine_type, :region, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
