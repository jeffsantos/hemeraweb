require 'soap/wsdlDriver'

# The proof functions allow authorized users
# to add, delete, list, and edit proofscripts.
# Only logged-in users can use some of these the actions.
class ProofController < ApplicationController
  
  before_filter :authorize, :except => [:index, :prove_no_saved]
  before_filter :before_call_service, :except => [:index, :prove_no_saved]   
  
  def index  
    if session[:user_id]
      redirect_to :controller => "admin", :action => "index"      
    else
      response.content_type = 'application/xhtml+xml'
    end
  end
  
  def prove_no_saved     
    if request.post?
      hash = params['proofscript']
      specification = hash['specification']
      prove(specification)
    end
  end
  
  def prove_saved
    prove(@proofscript.specification)
  end
  
  def check
    ret = @proofProcess.check_syntax(@proofscript.specification)
    if ret[0].class == SOAP::Mapping::Object
      @status_msg = "Specification ok, no errors found."
    else 
      @status_msg = ret[0]   
    end
    respond_to { |format| format.js }
  end

  def start
    ret = @proofProcess.start(@proofscript.user.id, @proofscript.specification)
    render_result_page(ret)   
  end
  
  def step
    ret = @proofProcess.step(@proofscript.user.id)
    render_result_page(ret)
  end

  def run
    ret = @proofProcess.run(@proofscript.user.id)
    render_result_page(ret)
  end
  
  private
  def before_call_service
    @proofscript = Proofscript.find(params[:id])
    @proofProcess = ProofProcess.new
  end
  
  def render_result_page(ret)
    if ret[0].class == String
      if ret[0][0, 5] == "Error"
        flash[:notice] = ret[0]    
      else      
        @svg = ret[0]
      end
    end    
    render :action => 'prove', :content_type => 'application/xhtml+xml'    
  end
  
  def prove(specification)
    begin
      ws = SOAP::WSDLDriverFactory.new('http://localhost:8081/HemeraService?wsdl').create_rpc_driver
      proof = ws.prove(specification)
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