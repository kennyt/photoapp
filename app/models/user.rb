class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username, :access_token
  attr_accessible :provider, :uid
  # attr_accessible :title, :body

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
end
