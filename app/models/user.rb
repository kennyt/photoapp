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
  }, :default_url => '/images/:style_blurred.jpg'

  has_many :photos
  has_many :likes
  has_many :liked_photos, :through => :likes, :source => :photo

  def self.find_for_facebook_oauth(auth)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first

    unless user
      user = User.create!(
        provider: auth.provider,
        uid: auth.uid,
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
    Photo.joins("JOIN likes AS likes1, likes AS likes2 ON likes1.photo_id = likes2.photo_id AND likes1.photo_id = photos.id")
         .where("likes1.user_id = ? and likes2.user_id = ?", user_being_viewed.id, id)
  end

  def find_photos_liked_by_person(user_liking)
    Photo.joins("JOIN likes AS likes1, users AS users1 ON users1.id = likes1.user_id AND photos.id = likes1.photo_id")
         .where("likes1.user_id = ? and users1.id", 1, 5)
  end
end
