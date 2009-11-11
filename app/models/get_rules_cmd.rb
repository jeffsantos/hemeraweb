class GetRulesCmd < ProverCommand

  def after_initialize
    super()
    self.name = "GetRulesCmd"
  end

  def execute(args = {})
    raise ActiveRecordError.new("Null args not allowed") if args.nil?
    id = args[:id]
    goal = args[:goal]
    soapObj = self.prover.get_rules(id, goal)
    
    if soapObj[0].__xmlele()[0]
      rules = soapObj[0].__xmlele()[0][1]      
    else
      rules = []
    end
    
    return rules
  end    
end