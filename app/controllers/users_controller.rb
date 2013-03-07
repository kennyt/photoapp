class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    if params[:mutual]
      @photos = current_user.find_mutual_photos(@user)
    elsif params[:he_liked]
      @photos = current_user.find_photos_liked_by_person(@user)
    elsif params[:you_liked]
      @photos = current_user.find_photos_you_liked_by_person(@user)
    else
      @photos = @user.photos
    end

    respond_to do |format|
      format.html
      format.json { render :json => @photos }
    end
  end

  def update
    current_user.update_attributes(params[:user])
    redirect_to photos_path
  end
end
