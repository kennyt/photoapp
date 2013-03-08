class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    if params[:mutual]
      @photos = current_user.find_mutual_photos(@user)
    elsif params[:he_liked]
      @photos = current_user.find_photos_you_or_other_person_liked(@user, 1)
    elsif params[:you_liked]
      @photos = current_user.find_photos_you_or_other_person_liked(@user, 2)
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
