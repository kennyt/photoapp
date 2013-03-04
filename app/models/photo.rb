class Photo < ActiveRecord::Base
  attr_accessible :image, :user_id

  belongs_to :user
end
