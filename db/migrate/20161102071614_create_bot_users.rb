class CreateBotUsers < ActiveRecord::Migration
  def change
    create_table :bot_users do |t|
      t.integer :bot_id
      t.string :cust_fb_id
      t.integer :msg_count, default: 0

      t.timestamps null: false
    end
  end
end
