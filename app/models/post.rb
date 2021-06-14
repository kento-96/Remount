class Post < ApplicationRecord
   attachment :image

  belongs_to :user
  has_many :comments
  has_many :favorites, dependent: :destroy

  has_many :post_tags
  has_many :tags, through: :post_tags

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def tags_save(tag_list)
    if self.tags != nil
      post_tags_records = PostTag.where(post_id: self.id)
      post_tags_records.destroy_all
    end

    tag_list.each do |tag|
      inspected_tag = Tag.where(tag_name: tag).first_or_create
      self.tags << inspected_tag
    end

  end
end
