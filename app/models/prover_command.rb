require 'soap/wsdlDriver'

class ProverCommand < ActiveRecord::Base
  belongs_to :proof_process
  attr_reader :prover
  
  CONNECTION_ERROR_MSG = "Error connecting with the prover web service. Try again or check your environment." 

  def after_initialize
    @prover = SOAP::WSDLDriverFactory.new('http://localhost:8081/HemeraService?wsdl').create_rpc_driver
  end
 
  def execute(args = {})

  end

end
