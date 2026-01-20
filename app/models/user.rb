class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :storages, dependent: :destroy
  has_many :wine_templates, dependent: :destroy
end
