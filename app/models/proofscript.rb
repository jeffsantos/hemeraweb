class Status
  NotStarted = "Not Started"
  Started = "Started"
  Proved = "Proved"
  CounterExample = "Counter Example" 
end


class Proofscript < ActiveRecord::Base
  validates_presence_of :title, :specification
  
  belongs_to :user
  has_many :prover_commands, :dependent => :destroy
  
  def check_syntax()
    command = CheckSyntaxCmd.new    
    ret, msg = command.execute(:spec => self.specification)
    return ret, msg
  end

  def start_proving()
    command = StartCmd.new
    ret, proofRepr, msg = command.execute(:id => self.user_id, :spec => self.specification)
    save_command(command, ":id => self.user_id, :spec => self.specification")    
    change_status(Status::Started) if ret
    return ret, proofRepr, msg
  end
  
  def run_proof_step(steps)
    command = StepCmd.new
    ret, proofRepr, msg = command.execute(:id => self.user_id)
    save_command(command, ":id => self.user_id")    
    change_status(Status::Proved) if msg == "No more goals."
    change_status(Status::CounterExample) if msg == "No proof rules applicable."    
    return ret, proofRepr, msg
  end

  def run_all_steps()
    command = RunCmd.new   
    ret, proofRepr, msg = command.execute(:id => self.user_id)
    save_command(command, ":id => self.user_id")    
    change_status(Status::Proved) if msg == "No more goals."
    change_status(Status::CounterExample) if msg == "No proof rules applicable."    
    return ret, proofRepr, msg    
  end
  
  def get_rules(goal)
    command = GetRulesCmd.new    
    rules = command.execute(:id => self.user_id, :goal => goal)
    return rules
  end
  
  def apply_rule(goal, ruleid)
    command = ApplyRuleCmd.new
    ret, proofRepr, msg = command.execute(:id => self.user_id, :goal => goal, :ruleid => ruleid)
    save_command(command, ":id => self.user_id, :goal => '#{goal}', :ruleid => #{ruleid}")    
    change_status(Status::Proved) if msg == "No more goals."
    change_status(Status::CounterExample) if msg == "No proof rules applicable."    
    return ret, proofRepr, msg
  end  
  
  def execute_command_log()
    ret = ""
    proofRepr = ""
    msg = ""
    
    prover_commands.each do |command|
      str = command.name + ".new"
      cmd = eval(str)
      str = "ret, proofRepr, msg = cmd.execute(" + command.args + ")"
      self.instance_eval(str)
    end
    return ret, proofRepr, msg
  end
  
  private 
  def save_command(cmd, args)
    cmd.proofscript_id = self.id
    cmd.args = args
    cmd.save    
  end
  
  def change_status(newStatus)
    self.status = newStatus
    self.save
  end  
end
