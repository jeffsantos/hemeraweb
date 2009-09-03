class CreateProofscripts < ActiveRecord::Migration
  def self.up
    create_table :proofscripts do |t|
      t.string :title
      t.text :specification

      t.timestamps
    end
  end

  def self.down
    drop_table :proofscripts
  end
end
