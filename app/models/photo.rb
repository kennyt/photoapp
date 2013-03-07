class Photo < ActiveRecord::Base
  attr_accessible :image_attached, :user_id

  has_attached_file :image_attached, :styles => {
    :big => "500x500>"
  }

  belongs_to :user
  has_many :likes
  has_many :users_liked, :through => :likes, :source => :user
  # validates :image, presence: true
end
