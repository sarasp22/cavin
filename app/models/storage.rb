class Storage < ApplicationRecord
  belongs_to :user
  has_many :wines, dependent: :nullify

  validates :name, presence: true
  validates :category, presence: true
  validates :rows, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }
  validates :cols, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }

  before_save :set_default_photo

  private

  def set_default_photo
    self.photo_url = case category
                     when "Cave"
                       "cave.jpg"
                     when "Vinothèque salon"
                       "vinotheque_salon.png"
                     when "Meuble cuisine"
                       "meuble_cuisine.jpg"
                     when "Vinothèque cuisine"
                       "vinotheque_cuisine.png"
                     when "Frigo"
                       if File.exist?(Rails.root.join("app/assets/images/frigo.png"))
                         "frigo.png"
                       elsif File.exist?(Rails.root.join("app/assets/images/frigo.jpg"))
                         "frigo.jpg"
                       else
                         "vinotheque_cuisine.png"
                       end
                     else
                       "default_storage.jpg"
                     end
  end
end
