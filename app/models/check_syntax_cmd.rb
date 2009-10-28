class CheckSyntaxCmd < ProverCommand

  def after_initialize
    super()
    self.name = "CheckSyntaxCmd"
  end

  def execute(args = {})
    raise ActiveRecordError.new("Null args not allowed") if args.nil?
    spec = args[:spec]
    
    begin
      ret = self.prover.check_syntax(spec)
    rescue
      logger.error("Attempt to check syntax of spec #{args[:spec]}")
      ret = 'Error connecting with the prover web service. Try again or check your environment.'                   
    end      
    ret
  end
end