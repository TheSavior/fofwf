namespace :fofwf do

  desc 'Generate sample data'
  task :generate => :environment do
    mt = MessageThread.new({:uuid_1 =>'1', :uuid_2 => '2', :mutual_friends => 'Eli White,Kyle Zemek,John Smith', :mutual_friends_found => 'Eli_White'})
    mt.save
    Message.create({:thread_id => mt.id, :sender_uuid => '1', :content => 'Message 1'})
    sleep 2
    Message.create({:thread_id => mt.id, :sender_uuid => '1', :content => 'Message 2'})
    sleep 2
    Message.create({:thread_id => mt.id, :sender_uuid => '1', :content => 'Message 3'})
    sleep 2
    Message.create({:thread_id => mt.id, :sender_uuid => '1', :content => 'Message 4'})
    sleep 2
    Message.create({:thread_id => mt.id, :sender_uuid => '1', :content => 'Message 5'})
  end
end
