class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update, :activity]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  autocomplete :user, :name, :full => true, :extra_data => [:email]

  def new
  	@user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @points = Points.where("user_id = " + params[:id].to_s).sum(:score)
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def points
    @points = Points.group(:user_id).sum(:score)
    @users = User.all
    render 'show_points'
  end

  def activity
    @points = Points.where("user_id = " + current_user.id.to_s).order("created_at desc")
    microposts = Micropost.where("user_id=" + current_user.id.to_s)
    comments = Comment.where('micropost_id in (?) or user_id=' + current_user.id.to_s, microposts.map{|k| k.id})
    followers = Relationship.where("follower_id=" + current_user.id.to_s + " or followed_id=" + current_user.id.to_s)
    @data = (microposts + comments + followers).sort_by(&:created_at).reverse
    render 'show_activity'
  end

  def search
    @user = User.where("name='"+ params[:name] + "'")[0]
    if !@user.nil?
      redirect_to @user
    else
      flash[:notice] = "Requested User doesnot Exist"
      redirect_back_or(current_user)
    end
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
