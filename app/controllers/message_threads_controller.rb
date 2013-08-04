class MessageThreadsController < ApplicationController
  def index
    @message_threads = MessageThread.where("uuid_1 = ? OR uuid_2 = ?", session['user_id'], session['user_id']);
    @message_threads_list = @message_threads.map do |u|
      time = ((Time.now() - u.updated_at) / 1.hour).round
      if time > 23
        time = ((Time.now() - u.updated_at) / 1.day).round.to_s + " days"
      else
        time = time.to_s + " hours"
      end
      {:id => u.id, :time => time, :total => u.mutual_friends.split(',').count, :current => u.mutual_friends_found.split(',').count, :friends => u.mutual_friends_found.split(',')}
    end
    puts  @message_threads_list
    render :json => @message_threads_list
  end

  def show
    @message_threads = MessageThread.find(params[:id])
  end
end
