class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  def eligible_points(user_id, activity)
    Points.where(created_at: 60.minutes.ago..DateTime.now,user_id: user_id,activity: activity).count < 5
  end

  def create_points(user_id, activity)
  	@points = Points.new()
  	@points.user_id = user_id
  	@points.activity = activity
  	score = 0
  	if activity == "MC"
  		score = 5
  	elsif activity == "MD"
  		score = 3
	elsif activity == "CC"
		score = 3
	elsif activity == "CD"
		score = 2
	elsif activity == "F"
		score = 2
	else
		score = 1
	end
	@points.score = score
	@points.save()
  end
end