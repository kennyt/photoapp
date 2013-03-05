class UsersController < ApplicationController
  def show
    @photos = current_user.photos
  end
end
