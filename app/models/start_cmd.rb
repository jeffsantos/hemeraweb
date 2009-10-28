class StartCmd < ProverCommand

  def after_initialize
    super()
    self.name = "StartCmd"
  end

  def execute(args = {})
    raise ActiveRecordError.new("Null args not allowed") if args.nil?
    id = args[:id]
    spec = args[:spec]    
    begin
      ret, msg = self.prover.start(id, spec)
    rescue
      logger.error("Attempt to start a proof process for user #{args[:id]} with spec #{args[:spec]}")
      return false, CONNECTION_ERROR_MSG
    else      
      return eval(ret), msg
    end
  end  
end