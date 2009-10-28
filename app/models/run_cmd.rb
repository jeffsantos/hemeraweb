class RunCmd < ProverCommand

  def after_initialize
    super()
    self.name = "RunCmd"
  end

  def execute(args = {})
    raise ActiveRecordError.new("Null args not allowed") if args.nil?
    id = args[:id]
    begin
      ret, proofRepr, msg = self.prover.run(id)
    rescue
      logger.error("Attempt to run all proof steps for user #{args[:id]}")
      return false, "", CONNECTION_ERROR_MSG
    else      
      return eval(ret), proofRepr, msg
    end
  end    
end