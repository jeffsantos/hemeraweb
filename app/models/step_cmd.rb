class StepCmd < ProverCommand

  def after_initialize
    super()
    self.name = "StepCmd"
  end

  def execute(args = {})
    raise ActiveRecordError.new("Null args not allowed") if args.nil?
    id = args[:id]
    begin
      ret, proofRepr, msg = self.prover.step(id)
    rescue
      logger.msg("Attempt to run a number of proof steps for user #{args[:id]}")
      return false, "", CONNECTION_ERROR_MSG
    else      
      return eval(ret), proofRepr, msg
    end
  end    
end