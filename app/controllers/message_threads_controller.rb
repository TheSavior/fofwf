class MessageThreadsController < ApplicationController
  def index
    if !session[user_id]
      redirect_to root_url
    end
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
    if !session['user_id']
      redirect_to root_url
    else
      @message_thread = MessageThread.find(params[:id])
      if session['user_id'] != @message_thread.uuid_1 && session['user_id'] != @message_thread.uuid_2
        render nothing: true, status: :unauthorized
      else
        @messages = Message.where("thread_id = ?", @message_thread.id)
        @messages_list = @messages.map do |u|
          sender_text = 'them'
          if u.sender_uuid == session['user_id']
            sender_text = 'me'
          end
          {:sender => sender_text,:timestamp => u.created_at, :text => u.content}
        end
        render :json => {:total_mutal_friends => @message_thread.mutual_friends.split(',').count, :number_matched => @message_thread.mutual_friends_found.split(',').count, :messages_list => @messages_list}
      end
    end
  end

  def attempt_match
    if !session['user_id']
      redirect_to root_url
    else
      @message_thread = MessageThread.find(params[:id])
      if session['user_id'] != @message_thread.uuid_1 && session['user_id'] != @message_thread.uuid_2
        rrender nothing: true, status: :unauthorized
      else
        if @message_thread.mutual_friends.split(',').any?{ |s| s.casecmp(params['guess'])==0 } && !@message_thread.mutual_friends_found.split(',').any?{ |s| s.casecmp(params['guess'])==0 }
          @message_thread.mutual_friends+= @message_thread.mutual_friends.split(',').count==0 ? '' : ',' + params['guess']
          @message_thread.save
          render :json => {:guess => 'correct'}
        else
          render :json => {:guess => 'incorrect'}
        end
      end
    end
  end
end
