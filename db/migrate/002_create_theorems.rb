class CreateTheorems < ActiveRecord::Migration
  def self.up
    create_table :theorems do |t|
    end
  end

  def self.down
    drop_table :theorems
  end
end
