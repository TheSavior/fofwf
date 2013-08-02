class CreateMessageThreads < ActiveRecord::Migration
  def change
    create_table :message_threads do |t|
      t.string :uuid_1
      t.string :uuid_2
      t.string :mutual_friends
      t.string :mutual_friends_found

      t.timestamps
    end
  end
end
