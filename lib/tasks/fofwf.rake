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
    node_me = $neo.get_node_index('user', 'id', 805780135)
    10.times do
      id = Random.rand(100000)+1
      node_friend = $neo.create_node("id" => id, "name" => 'friend' + (id).to_s)
      $neo.add_node_to_index('user', 'id', id, node_friend)
      $neo.set_node_properties(node_friend, {'last_login' => Time.now()})
      id_me = 805780135
      id_friend = id
      if(id_me < id_friend)
        val = id_me.to_s + '::' +id_friend.to_s
      else
        val = id_friend.to_s + '::' +id_me.to_s
      end
      rel = $neo.create_relationship("friend", node_me, node_friend)
      $neo.add_relationship_to_index('friend', 'ids', val, rel)
    end

    node_me = $neo.get_node_index('user', 'id', 567757054)
    10.times do
      id = Random.rand(100000)+1
      node_friend = $neo.create_node("id" => id, "name" => 'friend' + (id).to_s)
      $neo.add_node_to_index('user', 'id', id, node_friend)
      $neo.set_node_properties(node_friend, {'last_login' => Time.now()})
      id_me = 567757054
      id_friend = id
      if(id_me < id_friend)
        val = id_me.to_s + '::' +id_friend.to_s
      else
        val = id_friend.to_s + '::' +id_me.to_s
      end
      rel = $neo.create_relationship("friend", node_me, node_friend)
      $neo.add_relationship_to_index('friend', 'ids', val, rel)
    end
  end

  task :test => :environment do
     query = "START a=node:user(id=\"805780135\") "\
      "MATCH a-[:friend*2..2]-friend_of_friend "\
      "WHERE NOT (a-[:friend]-friend_of_friend) "\
      "AND NOT (a-[:thread]-friend_of_friend) "\
      "AND HAS(friend_of_friend.last_login) "\
      "RETURN friend_of_friend"
    puts "+++++++++++++++++++++++++++++++++++++" + Time.now().to_s
    response = $neo.execute_query(query)
    puts "=======================================" +Time.now().to_s
    puts "+++++++++++++++++++++++++++++++++++++" + Time.now().to_s
    response = $neo.execute_query(query)
    puts "=======================================" +Time.now().to_s
    puts "+++++++++++++++++++++++++++++++++++++" + Time.now().to_s
    response = $neo.execute_query(query)
    puts "=======================================" +Time.now().to_s
    puts "+++++++++++++++++++++++++++++++++++++" + Time.now().to_s
    response = $neo.execute_query(query)
    puts "=======================================" +Time.now().to_s
  end
end
