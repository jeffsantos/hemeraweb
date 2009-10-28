require 'soap/wsdlDriver'

class ProverCommand < ActiveRecord::Base
  belongs_to :proof_process
  attr_reader :prover

  def after_initialize
    @prover = SOAP::WSDLDriverFactory.new('http://localhost:8081/HemeraService?wsdl').create_rpc_driver
  end
 
  def execute(args = {})

  end

end
