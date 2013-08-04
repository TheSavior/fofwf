class AppController < ApplicationController

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    @graph = Koala::Facebook::API.new(user.oauth_token)

    profile = @graph.get_object("me")
    friends = @graph.get_connections("me", "friends")
    puts friends
    puts friends.size
    redirect_to root_url
  end
  def index

  end

  def show

  end
end
