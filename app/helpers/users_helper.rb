module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 70 })
  	gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  	size = options[:size]
  	gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  	image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def convert_action_to_activity(action)
  	if action == "MC"
  		return "You Created a Micropost"
  	elsif action == "MD"
  		return "You Destroyed a Micropost"
  	elsif action == "CC"
  		return "You Created a Comment"
  	elsif action == "CD"
  		return "You Destroyed a Comment"
  	elsif action == "F"
  		return "You followed a user"
  	else
  		return "You unfollowed a user"
  	end
  end
end