class ProofProcess < ActiveRecord::Base
  belongs_to :proofscript
  has_many :prover_commands
  
  attr_reader :commands
  
  def after_initialize 
    @commands = [] 
  end  
  
  def check_syntax(spec)
    command = CheckSyntaxCmd.new
    @commands << command    
    ret = command.execute(:spec => spec)
    ret
  end

  def start(id, spec)
    command = StartCmd.new
    @commands << command        
    ret = command.execute(:id => id, :spec => spec)
    ret
  end
  
  def step(id)
    command = StepCmd.new
    @commands << command    
    ret = command.execute(:id => id)
    ret
  end

  def run(id)
    command = RunCmd.new
    @commands << command    
    ret = command.execute(:id => id)
    ret    
  end  
  
end
