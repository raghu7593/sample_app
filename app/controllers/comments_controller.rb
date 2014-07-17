class CommentsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def index
  end

  def create
  	@comment = current_user.comments.build(params[:comment])
    if @comment.save
      if eligible_points(current_user.id, "CC")
        create_points(current_user.id, "CC")
      end
    else
      @feed_items = []
      @errors = @comment.errors.full_messages
    end
    @comments = @comment.micropost.comments
    @micropostid = @comment.micropost_id
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def destroy
  	@comment.destroy
    if eligible_points(current_user.id, "CD")
      create_points(current_user.id, "CD")
    end
    @micropostid = @comment.micropost_id
    @comments = @comment.micropost.comments
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def correct_user
      @comment = current_user.comments.find_by_id(params[:id])
      redirect_to root_url if @comment.nil?
    end
end