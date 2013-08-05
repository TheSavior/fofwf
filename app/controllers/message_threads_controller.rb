require 'neography'

class MessageThreadsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
    if !session['user_id']
      redirect_to root_url and return
    end
    @message_threads = MessageThread.where("uuid_1 = ? OR uuid_2 = ?", session['user_id'], session['user_id']);
    @message_threads_list = @message_threads.map do |u|
      @message = Message.find(:first, :conditions =>["thread_id = ?", u.id], :order => "created_at DESC")
      content = ''
      if @message
        content = @message.content[0..100]
      end
      time = ((Time.now() - u.updated_at) / 1.hour).round
      if time > 23
        time = ((Time.now() - u.updated_at) / 1.day).round.to_s + " days"
      else
        time = time.to_s + " hours"
      end
      {:id => u.id,
       :time => time,
       :total => u.mutual_friends.split(',').count,
       :current => u.mutual_friends_found.split(',').count,
       :friends => u.mutual_friends_found.split(','),
       :last_message => content}
    end
    puts  @message_threads_list
    render :json => @message_threads_list
  end

  def show
    if !session['user_id']
      redirect_to root_url and return
    end
    @message_thread = MessageThread.find_by_id(params[:id])
    if !@message_thread
      render nothing: true, status: :not_found and return
    end
    if session['user_id'] != @message_thread.uuid_1 && session['user_id'] != @message_thread.uuid_2
      render nothing: true, status: :unauthorized and return
    end
    @messages = Message.where("thread_id = ?", @message_thread.id)
    @messages_list = @messages.map do |u|
      sender_text = 'them'
      if u.sender_uuid == session['user_id']
        sender_text = 'me'
      end
      {:sender => sender_text,:timestamp => u.created_at, :text => u.content}
    end
    render :json => {:total_mutal_friends => @message_thread.mutual_friends.split(',').count,
                     :number_matched => @message_thread.mutual_friends_found.split(',').count,
                     :messages_list => @messages_list}
  end


  def attempt_match
    if !session['user_id']
      redirect_to root_url and return
    end
    @message_thread = MessageThread.find_by_id(params[:id])
    if !@message_thread
      render nothing: true, status: :not_found and return
    end
    if session['user_id'] != @message_thread.uuid_1 && session['user_id'] != @message_thread.uuid_2
      render nothing: true, status: :unauthorized and return
    end
    if @message_thread.mutual_friends.split(',').any?{ |s| s.casecmp(params['guess'])==0 } && !@message_thread.mutual_friends_found.split(',').any?{ |s| s.casecmp(params['guess'])==0 }
      @message_thread.mutual_friends_found+= @message_thread.mutual_friends_found.split(',').count==0 ? '' : ',' + params['guess']
      @message_thread.save
      render :json => {:guess => 'correct', :count => @message_thread.mutual_friends_found.split(',').count}
    else
      render :json => {:guess => 'incorrect'}
    end
  end

  def create
    query = "START a=node:user(id=\""+session['user_id']+"\") "\
      "MATCH a-[friend*2..2]-friend_of_friend "\
      "WHERE NOT (a-[friend*0..1]-friend_of_friend) "\
      "AND NOT (a-[thread*1..1]-friend_of_friend) "\
      "AND HAS(friend_of_friend.last_login) "\
      "RETURN DISTINCT friend_of_friend"
    puts "+++++++++++++++++++++++++++++++++++++" + Time.now().to_s
    response = $neo.execute_query(query,{:stats => true, :profile => true})
    puts response
    response = response['data'][-1]

    puts "=======================================" +Time.now().to_s
    if response
      @message_thread = MessageThread.new
      @message_thread.uuid_1 = session['user_id']
      @message_thread.uuid_2 = response[-1]['data']['id']
      query = "START a=node:user(id=\""+session['user_id'].to_s+"\"), b=node:user(id=\""+response[-1]['data']['id'].to_s+"\")"\
        "MATCH a--x--b "\
        "RETURN DISTINCT x"
      mutual_friends = $neo.execute_query(query)['data']
      mfs =''
      mutual_friends.each do |mf|
        mfs += ','+mf[-1]['data']['name']
      end
      @message_thread.mutual_friends=mfs[1..-1]
      @message_thread.mutual_friends_found = ''
      @message_thread.save
      node_me = $neo.get_node_index('user', 'id', @message_thread.uuid_1)
      node_friend = $neo.get_node_index('user', 'id', @message_thread.uuid_2)
      $neo.create_relationship("thread", node_me, node_friend)
      render json: {:found => true, :thread_id => @message_thread.id, :total =>  @message_thread.mutual_friends.split(',').count} and return
    end
    render json: {:found => false}
  end
end
