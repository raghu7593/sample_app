class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @points = Points.where("user_id = " + current_user.id.to_s).sum(:score)
    end
  end

  def help
  end

  def about
  end
end
