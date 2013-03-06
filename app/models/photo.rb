class Photo < ActiveRecord::Base
  attr_accessible :image, :user_id

  belongs_to :user
  has_many :likes
  has_many :users_liked, :through => :likes, :source => :user
  validates :image, presence: true
end
