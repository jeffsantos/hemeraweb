class ApplyRuleCmd < ProverCommand

  def after_initialize
    super()
    self.name = "ApplyRuleCmd"
  end

  def execute(args = {})
    raise ActiveRecordError.new("Null args not allowed") if args.nil?
    id = args[:id]
    goal = args[:goal]
    ruleid = args[:ruleid]
    ret, proofRepr, msg = self.prover.apply_rule(id, goal, ruleid)     
    return eval(ret), proofRepr, msg
  end    
end