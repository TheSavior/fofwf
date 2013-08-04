namespace :fofwf do

  desc 'Generate sample data'
  task :generate => :environment do
    mt = MessageThread.new({:uuid_1 =>'805780135', :uuid_2 => '567757054', :mutual_friends => 'Eli White,Kyle Zemek,John Smith', :mutual_friends_found => 'Eli White'})
    mt.save
    Message.create({:thread_id => mt.id, :sender_uuid => '805780135', :content => 'Message 1'})
    sleep 2
    Message.create({:thread_id => mt.id, :sender_uuid => '567757054', :content => 'Message 2'})
    sleep 2
    Message.create({:thread_id => mt.id, :sender_uuid => '567757054', :content => 'Message 3'})
    sleep 2
    Message.create({:thread_id => mt.id, :sender_uuid => '805780135', :content => 'Message 4'})
    sleep 2
    Message.create({:thread_id => mt.id, :sender_uuid => '805780135', :content => 'Message 5'})
  end
  desc 'Generate sample data'
  task :neo4j => :environment do
    @neo = Neography::Rest.new
    node_me = @neo.get_node_index('user', 'id', 805780135)
    node =  @neo.execute_query("START a=node:user(id=\"935108\") "\
                               "MATCH a-[friend*2..2]-friend_of_friend "\
                               "WHERE NOT (a-[friend*0..1]-friend_of_friend) "\
                               "AND HAS(friend_of_friend.last_login) "\
                               "RETURN DISTINCT friend_of_friend")
    puts node['data'][-1][-1]['data']
    prop = @neo.get_node_properties(node_me, ['id'])['id']
    puts prop

  end
end
