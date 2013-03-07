class PhotosController < ApplicationController
  before_filter :authenticate_user!

  def index
    @photos = Photo.order('created_at DESC').all
    @user = current_user
  end

  def new
    @photo = Photo.new
  end

  def create
    image = params[:photo].delete(:image)
    @photo = current_user.photos.build(params[:photo])
    @photo.image = image.read if image

    if @photo.save
      UserMailer.photo_post_inform(current_user).deliver
      redirect_to photos_path
    else
      @photo = Photo.new
      render 'photos/new'
    end
  end

  def image
    photo = Photo.find(params[:id])
    send_data(photo.image, type: 'image/jpg', disposition: 'inline')
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def destroy
    photo = Photo.find(params[:id])
    photo.destroy

    respond_to do |format|
      format.json { render :json => current_user }
    end
  end
end
