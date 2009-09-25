require 'soap/wsdlDriver'

# The proof functions allow authorized users
# to add, delete, list, and edit proofscripts.
# Only logged-in users can use some of these the actions.
class ProofController < ApplicationController
  
  def authorize  

  end
  
  def index  
    if session[:user_id]
      redirect_to :controller => "admin", :action => "index"      
    else
      response.content_type = 'application/xhtml+xml'
    end
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
      ws = SOAP::WSDLDriverFactory.new('http://localhost:8081/HemeraService?wsdl').create_rpc_driver
      proof = ws.prove(formula)
      if proof[0][0, 5] == 'Error'
        flash[:notice] = 'Syntax Error in the input formula. Please, check the language syntax in the dictionary.'
        redirect_to(:back)
      else
        @svg = proof
        render :action => 'prove', :content_type => 'application/xhtml+xml'        
      end  
    rescue
      logger.error("Attempt to access prove formula #{params[:id]}")
      flash[:notice] = 'Error connecting with the prover web service. Try again or check your environment.'
      if session[:user_id]
        redirect_to(:back)
      else
        redirect_to(:action => 'prove_no_saved') 
      end                    
    end
  end

 end