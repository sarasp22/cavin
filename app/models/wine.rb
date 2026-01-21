class Wine < ApplicationRecord
 belongs_to :storage, touch: true
end
