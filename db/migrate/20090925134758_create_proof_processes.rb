class CreateProofProcesses < ActiveRecord::Migration
  def self.up
    create_table :proof_processes do |t|
      t.string :status
      t.integer :proofscript_id, :null => false, :options => 
        "CONSTRAINT fk_proof_process_proofscripts REFERENCES proofscripts(id)"         

      t.timestamps
    end
  end

  def self.down
    drop_table :proof_processes
  end
end
