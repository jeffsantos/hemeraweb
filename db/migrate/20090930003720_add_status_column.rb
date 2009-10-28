class AddStatusColumn < ActiveRecord::Migration
  def self.up
    add_column :proofscripts, :status, :string    
  end

  def self.down
    remove_column :proofscripts, :status
  end
end
