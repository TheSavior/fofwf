require 'neography'

class AppController < ApplicationController

  def create
    session[:user_id] = env["omniauth.auth"].uid
    Thread.new do
      @graph = Koala::Facebook::API.new(env["omniauth.auth"].credentials.token)
      profile = @graph.get_object("me")
      friends = @graph.get_connections("me", "friends")
      node_me = $neo.get_node_index('user', 'id', session[:user_id])
      if !node_me
        node_me = $neo.create_node("id" => session[:user_id], "name" => env['omniauth.auth'].info.name)
        $neo.add_node_to_index('user', 'id', session[:user_id], node_me)
      end
      $neo.set_node_properties(node_me, {'last_login' => Time.now()})
      friends.each do |friend|
        node_friend = $neo.get_node_index('user', 'id', friend['id'])
        if !node_friend
          node_friend = $neo.create_node("id" => friend['id'], "name" => friend['name'])
          $neo.add_node_to_index('user', 'id', friend['id'], node_friend)
        end
        id_me = $neo.get_node_properties(node_me, ['id'])['id']
        id_friend = $neo.get_node_properties(node_friend, ['id'])['id']
        if(id_me < id_friend)
          val = id_me.to_s + '::' +id_friend.to_s
        else
          val = id_friend.to_s + '::' +id_me.to_s
        end
        rel = $neo.get_relationship_index('friend', 'ids', val)
        if !rel
          rel = $neo.create_relationship("friend", node_me, node_friend)
          $neo.add_relationship_to_index('friend', 'ids', val, rel)
        end
      end
    end
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
