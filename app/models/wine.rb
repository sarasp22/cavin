class Wine < ApplicationRecord
  belongs_to :user
  belongs_to :storage, touch: true, optional: true

  validates :name, :wine_type, presence: true

  SIZES = ['37.5cl', '75cl', '1.5L (Magnum)', '3L (Jéroboam)', '6L (Mathusalem)']
  validates :size, inclusion: { in: SIZES }, allow_blank: true
end
