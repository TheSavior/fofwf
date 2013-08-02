class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sender_uuid
      t.text :content

      t.timestamps
    end
  end
end
