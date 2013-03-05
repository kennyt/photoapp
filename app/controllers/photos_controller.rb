class PhotosController < ApplicationController
  before_filter :authenticate_user!

  def index
    @photos = Photo.order('created_at DESC').all
  end

  def new
    @photo = Photo.new
  end

  def create
    image = params[:photo].delete(:image)
    image = image.read if image
    @photo = current_user.photos.build(params[:photo])
    @photo.image = image

    if @photo.save
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
end
