class AddTestData < ActiveRecord::Migration
  def self.up
    Proofscript.delete_all 

    Proofscript.create(:title => 'Simple theorem',
                      :specification => '(a & b) |- a')
    
    Proofscript.create(:title => 'Complex theorem',
                      :specification => '(p1 --> p2) & (p1 --> (p2 --> p3)) & (p2 --> (p3 --> p4)) |- p1 --> p4')
                      
    Proofscript.create(:title => "Hemera's site theorem",
                      :specification => '(p | q) & (p | r) |- p | (q & r)')
                                     
  end

  def self.down
    Proofscript.delete_all 
  end
end
