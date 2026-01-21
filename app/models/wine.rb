class Wine < ApplicationRecord
  belongs_to :user
  belongs_to :storage, touch: true, optional: true

  validates :name, :wine_type, presence: true
end
