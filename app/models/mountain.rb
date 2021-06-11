class Mountain < ApplicationRecord
  belongs_to :user
  attachment :mountain_image
end
