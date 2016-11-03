class AddColumnToBots < ActiveRecord::Migration
  def change
    add_column :bots, :name, :string
    add_column :bots, :page_id, :string
  end
end
