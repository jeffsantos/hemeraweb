class AddUserToProofscript < ActiveRecord::Migration
  def self.up
    drop_table :proofscripts

    create_table :proofscripts do |t|
      t.string :title
      t.text :specification
      t.integer :user_id, :null => false, :options => 
        "CONSTRAINT fk_proofscript_users REFERENCES users(id)" 

      t.timestamps
    end
  end

  def self.down
    drop_table :proofscripts
    
     create_table :proofscripts do |t|
      t.string :title
      t.text :specification

      t.timestamps
    end   
  end

end
