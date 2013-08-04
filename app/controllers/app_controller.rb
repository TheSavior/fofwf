class AppController < ApplicationController

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    @graph = Koala::Facebook::API.new(user.oauth_token)
    profile = @graph.get_object("me")
    friends = @graph.get_connections("me", "friends")
    redirect_to root_url
  end
  def index
    if !session[:user_id]
      redirect_to :controller=>'login', :action => 'index'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :controller=>'login', :action => 'index'
  end
end
