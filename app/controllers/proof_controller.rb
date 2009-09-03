require 'soap/wsdlDriver'

# The proof functions allow authorized users
# to add, delete, list, and edit proofscripts.
# Only logged-in users can use some of these the actions.
class ProofController < ApplicationController
  
  def authorize  

  end
  
  def index  
    response.content_type = 'application/xhtml+xml'
  end
  
  # Prove a formula when the user is not logged in.
  def prove_no_saved     
    if request.post?
      hash = params['proofscript']
      specification = hash['specification']
      prove(specification)
    end
  end
  
  def prove_saved
    @proofscript = Proofscript.find(params[:id])
    prove(@proofscript.specification)
  end
  
  private
  def prove(formula)
    begin
      ws = SOAP::WSDLDriverFactory.new('http://localhost:8080/HemeraService?wsdl').create_rpc_driver
      proof = ws.prove(formula)
      @svg = proof  
    rescue
      logger.error("Attempt to access prove formula #{params[:id]}")
      flash[:notice] = 'Error connecting with the prover web service. Try again or check your environment.'
      if session[:user_id]
        redirect_to(:action => 'prove_no_saved')
      else
        redirect_to(:action => 'prove_saved') 
      end      
    else  
      render :action => 'prove', :content_type => 'application/xhtml+xml'
    end
  end

 end