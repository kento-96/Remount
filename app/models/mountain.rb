class Mountain < ApplicationRecord
  belongs_to :user
  attachment :mountain_image
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
# 　geocoded_byが入力した住所から緯度経度を保存。
# 　after_validation :geocodeは後に住所変更があっても、変更後の緯度経度を保存してくれる。

  with_options presence: true do
    validates :mountain_name, length: { maximum: 25 }
    validates :mountain_body
    validates :address
  end

end
