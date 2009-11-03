require 'soap/wsdlDriver'

# The proof functions allow authorized users
# to add, delete, list, and edit proofscripts.
# Only logged-in users can use some of these the actions.
class ProofController < ApplicationController
  
  before_filter :authorize, :before_call_service, 
            :except => [:index, :prove_no_saved, :dictionary, :tutorial]
  
  def dictionary
    
  end
  
  def tutorial
    
  end
  
  def index  
    if session[:user_id]
      redirect_to :controller => "admin", :action => "index"      
    end
  end
  
  def prove
    if @proofscript.status == Status::NotStarted
      redirect_to :controller => 'proofscripts', :action => 'show', :id => @proofscript
    else   
      ret, proofRepr, msg = @proofscript.execute_command_log()
      render_result_page(ret, proofRepr, msg)
    end    
  end
  
  def check
    ret, msg = @proofscript.check_syntax()
    if ret
      @status_msg = "Specification ok, no errors found."
    else 
      @status_msg = msg
    end
    respond_to { |format| format.js }
  end

  def start        
    ret, proofRepr, msg = @proofscript.start_proving()
    render_result_page(ret, proofRepr, msg)
  end
  
  def step
    ret, proofRepr, msg = @proofscript.run_proof_step(1)
    render_result_page(ret, proofRepr, msg)
  end

  def run
    ret, proofRepr, msg = @proofscript.run_all_steps()
    render_result_page(ret, proofRepr, msg)
  end
  
  def prove_no_saved     
    if request.post?
      hash = params['proofscript']
      specification = hash['specification']
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
  
  private
  def before_call_service
    @proofscript = Proofscript.find(params[:id])   
  end
  
  def render_result_page(ret, proofRepr, msg)
    if ret
      @svg = proofRepr          
    else      
      flash[:notice] = msg
    end    
    render :action => 'prove', :content_type => 'application/xhtml+xml'
  end  

 end