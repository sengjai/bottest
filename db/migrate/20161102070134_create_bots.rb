class CreateBots < ActiveRecord::Migration
  def change
    create_table :bots do |t|
      t.belongs_to :user, index: true
      t.string :token
      t.string :uri
      t.string :secret

      t.timestamps null: false
    end
  end
end
