class AppController < ApplicationController

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_url
  end
  def index

  end

  def show

  end

  def me
    render :text => rest_graph.get('me').inspect
  end

  private

    def filter_setup_rest_graph
      rest_graph_setup(:auto_authorize => true)
    end
end
