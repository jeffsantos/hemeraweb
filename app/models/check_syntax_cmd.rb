class CheckSyntaxCmd < ProverCommand

  def after_initialize
    super()
    self.name = "CheckSyntaxCmd"
  end

  def execute(args = {})
    raise ActiveRecordError.new("Null args not allowed") if args.nil?
    spec = args[:spec]
    ret, msg = self.prover.check_syntax(spec)
    return eval(ret), msg
  end
end