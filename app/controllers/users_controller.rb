class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    if params[:mutual]
      @photos = Photo.join(:likes)
    else
      @photos = @user.photos
    end

    respond_to do |format|
      format.html
      format.json { render :json => @photos }
    end
  end
end
