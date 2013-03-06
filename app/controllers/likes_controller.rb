class LikesController < ApplicationController
  def create
    @like = Like.create(:photo_id => params[:like][:photo_id],
                        :user_id => current_user.id)
    @like.save!


    respond_to do |format|
      format.json { render :json => current_user}
    end
  end
end
