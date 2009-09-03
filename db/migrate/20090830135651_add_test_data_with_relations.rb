class AddTestDataWithRelations < ActiveRecord::Migration
  def self.up
    User.delete_all
    
    user = User.create(:name => 'jefferson',
                       :password => 'larinha',
                       :password_confirmation => 'larinha')
    
    Proofscript.delete_all 

    Proofscript.create(:title => 'Simple theorem',
                      :specification => '(a & b) |- a',
                      :user => user)
    
    Proofscript.create(:title => 'Complex theorem',
                      :specification => '(p1 --> p2) & (p1 --> (p2 --> p3)) & (p2 --> (p3 --> p4)) |- p1 --> p4',
                      :user => user)
                      
    Proofscript.create(:title => "Hemera's site theorem",
                      :specification => '(p | q) & (p | r) |- p | (q & r)',
                      :user => user)
                                     
  end

  def self.down
    User.delete_all
    Proofscript.delete_all 
  end
end
