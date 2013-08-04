class LoginController < ApplicationController
  def index
    if session['user_id']
      redirect_to root_url
    end
  end
end
