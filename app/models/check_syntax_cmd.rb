class CheckSyntaxCmd < ProverCommand

  def after_initialize
    super()
    self.name = "CheckSyntaxCmd"
  end

  def execute(args = {})
    raise ActiveRecordError.new("Null args not allowed") if args.nil?
    spec = args[:spec]
    begin
      ret, msg = self.prover.check_syntax(spec)
    rescue
      logger.error("Attempt to check syntax of spec #{args[:spec]}")
      return false, CONNECTION_ERROR_MSG
    else      
      return eval(ret), msg
    end
  end
end