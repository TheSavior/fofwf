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
end
