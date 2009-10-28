class CreateProverCommands < ActiveRecord::Migration
  def self.up
    create_table :prover_commands do |t|
      t.string :name
      t.string :args
      t.integer :proof_process_id, :null => false, :options => 
        "CONSTRAINT fk_prover_command_proof_processes REFERENCES proof_process(id)"    

      t.timestamps
    end
  end

  def self.down
    drop_table :prover_commands
  end
end
