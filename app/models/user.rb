class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username, :access_token
  attr_accessible :provider, :uid, :profile_picture

  has_attached_file :profile_picture, :styles => {
    :big => "600x600>",
    :small => "70x70#"
  }

  has_many :photos
  has_many :likes
  has_many :liked_photos, :through => :likes, :source => :photo

  def self.find_for_facebook_oauth(auth)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first

    unless user
      user = User.create!(
        provider: auth.provider,
        uid: auth.uid,
        username: auth.info.name,
        email: auth.info.email,
        access_token: auth.credentials.token,
        password: Devise.friendly_token[0,20]
      )
    end

    user
  end

  def facebook_friends
    graph = Koala::Facebook::API.new(access_token)
    graph.get_object("me")
    graph.get_connections("me", "friends")
  end

  def find_mutual_photos(user_being_viewed)
    Photo.joins("join likes as likes1, likes AS likes2
                 on likes1.photo_id = likes2.photo_id and likes1.photo_id = photos.id")
         .where("likes1.user_id = ? and likes2.user_id = ?", user_being_viewed.id, id)
  end

  def find_photos_you_or_other_person_liked(user_being_viewed, type)
    if type == 1
      user_who_is_liking, user_who_posted = user_being_viewed, self
    else
      user_who_is_liking, user_who_posted = self, user_being_viewed
    end

    Photo.joins("join likes AS likes1 on likes1.photo_id = photos.id")
         .where("likes1.user_id = ? and photos.user_id = ?",
                 user_who_is_liking.id, user_who_posted.id)
  end
end
