class MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def create
    if !session['user_id']
      redirect_to root_url and return
    end
    message = Message.new
    message.sender_uuid = session['user_id']
    message.content = params[:content]
    message.thread_id = params[:thread_id]
    message.save
    render json: {:status => 'ok'}
  end
end
