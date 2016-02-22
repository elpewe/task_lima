module UsersHelper
  # Returns the Gravatar for the given user.
 def gravatar_for(user, options = { size: 60 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    image_tag(gravatar_url, alt: user.username, class: "gravatar")
  end
end
