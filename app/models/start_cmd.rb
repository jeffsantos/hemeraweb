class StartCmd < ProverCommand

  def after_initialize
    super()
    self.name = "StartCmd"
  end

  def execute(args = {})
    raise ActiveRecordError.new("Null args not allowed") if args.nil?
    id = args[:id]
    spec = args[:spec]    
    ret, proofRepr, msg = self.prover.start(id, spec)
    return eval(ret), proofRepr, msg
  end  
end