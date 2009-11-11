class RunCmd < ProverCommand

  def after_initialize
    super()
    self.name = "RunCmd"
  end

  def execute(args = {})
    raise ActiveRecordError.new("Null args not allowed") if args.nil?
    id = args[:id]
    ret, proofRepr, msg = self.prover.run(id)     
    return eval(ret), proofRepr, msg
  end    
end