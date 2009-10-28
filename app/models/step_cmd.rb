class StepCmd < ProverCommand

  def after_initialize
    super()
    self.name = "StepCmd"
  end

  def execute(args = {})
    raise ActiveRecordError.new("Null args not allowed") if args.nil?
    id = args[:id]
    
    begin
      ret = self.prover.step(id)
    rescue
      logger.error("Attempt to run a number of proof steps for user #{args[:id]}")
      ret = 'Error connecting with the prover web service. Try again or check your environment.'                   
    end      
    ret
  end    
end