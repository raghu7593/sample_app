class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    if eligible_points(current_user.id, "F")
      create_points(current_user.id, "F")
    end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    if eligible_points(current_user.id, "UF")
      create_points(current_user.id, "UF")
    end
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end