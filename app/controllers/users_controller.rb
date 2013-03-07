class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    if params[:mutual]
      @photos = current_user.find_mutual_photos(@user)
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
