class AppController < ApplicationController

  def create
    session[:user_id] = env["omniauth.auth"].uid
    @graph = Koala::Facebook::API.new(env["omniauth.auth"].credentials.token)
    profile = @graph.get_object("me")
    friends = @graph.get_connections("me", "friends")
    @neo = Neography::Rest.new
    node_me = @neo.get_node_index('user', 'id', session[:user_id])
    if !node_me
      node_me = @neo.create_node("id" => session[:user_id], "name" => env['omniauth.auth'].info.name)
      @neo.add_node_to_index('users', 'id', session[:user_id], node_me)
    end
    @neo.set_node_properties(node_me, {'last_login' => Time.now()})
    friends.each do |friend|
      node_friend = @neo.get_node_index('user', 'id', friend['id'])
      if !node_friend
        node_friend = @neo.create_node("id" => friend['id'], "name" => friend['name'])
        @neo.add_node_to_index('user', 'id', friend['id'], node_friend)
      end
      rel = @neo.create_relationship("friend", node_friend, node_me)
    end
    redirect_to root_url
  end
  def index
    #if !session[:user_id]
    #  redirect_to :controller=>'login', :action => 'index'
    #end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :controller=>'login', :action => 'index'
  end
end
