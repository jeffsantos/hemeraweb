require 'soap/wsdlDriver'

# The proof functions allow authorized users
# to add, delete, list, and edit theorems.
# Only logged-in users can use some of these the actions.
class ProofController < ApplicationController
  before_filter :authorize, :except => [:new, :index, :dictionary, :prove_or_save]
  
  # An alias for #new, enabling users to prove formulas.
  def index  
    new
    render :action => 'new'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  # List all current theorems.
  def list
    @theorem_pages, @theorems = paginate :theorems, :per_page => 10, :conditions => ["user_id = ? ", session[:user_id]]
  end

  # Show details of a particular formula
  def show
    @theorem = Theorem.find(params[:id])
  end

  #enables users to prove formulas.
  def new

  end
 
  def prove_or_save
    commit = params['commit']
    if commit == 'Prove'
      prove_no_saved
    else
      save
    end    
  end
  
  # Include formulas in "My theorems".
  def save 
    hash = params['theorem']
    formula = hash['formula']
    @theorem = Theorem.new
    @theorem.formula = formula
    @theorem.user_id = session[:user_id]
    if @theorem.save
      flash[:notice] = 'Theorem was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end  
  
  # Prove a formula when the user is not logged in.
  def prove_no_saved       
    hash = params['theorem']
    formula = hash['formula']
    prove(formula)      
  end

  # Prove a formula when the user is logged in.
  def prove_saved
    @theorem = Theorem.find(params[:id])
    prove(@theorem.formula)
  end

  # Update an existing theorem based on values
  # from the form.
  def update
    @theorem = Theorem.find(params[:id])
    if @theorem.update_attributes(params[:theorem])
      flash[:notice] = 'Theorem was successfully updated.'
      redirect_to :action => 'show', :id => @theorem
    else
      render :action => 'edit'
    end
  end

  # Deletes a saved theorem.
  def destroy
    Theorem.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  private
  def prove(formula)
    ws = SOAP::WSDLDriverFactory.new('http://169.254.3.230:8080/HemeraService?wsdl').create_rpc_driver
    proof = ws.prove(formula)
    puts proof    
    @svg = proof
    render :action => 'prove'  
    
    rescue
    logger.error("Attempt to access prove formula #{params[:id]}")
    flash[:notice] = 'Error connecting with the prover web service. Try again or check your environment.'
    redirect_to(:action => 'new')        
  end
  
  def open_svg_test
    svg_str = ' 
 <svg width="400" height="400" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
 
 <g id="graph0" class="graph" transform="scale(1.333 1.333) rotate(0) translate(4 128)">

   <title>_anonymous_0</title>
   <polygon style="fill:white;stroke:white;" points="-4,4 -4,-128 90,-128 90,4 -4,4"/>
  
   <!-- (a &amp; b) |&#45; a -->
   <g id="node1" class="node"><title>(a &amp; b) |&#45; a</title>
     <ellipse style="fill:none;stroke:black;" cx="43" cy="-106" rx="42.9709" ry="18"/>
     <text text-anchor="middle" x="43" y="-100" style="font-family:Nimbus Roman No9 L;font-weight:regular;font-size:11.34pt;">(a &amp; b) |&#45; a</text>
   </g>
  
   <!-- a, b |&#45; a -->
   <g id="node3" class="node"><title>a, b |&#45; a</title>
     <ellipse style="fill:none;stroke:black;" cx="43" cy="-18" rx="32.971" ry="18"/>
     <text text-anchor="middle" x="43" y="-12" style="font-family:Nimbus Roman No9 L;font-weight:regular;font-size:11.34pt;">a, b |&#45; a</text>
   </g>
  
   <!-- (a &amp; b) |&#45; a&#45;&#45;a, b |&#45; a -->
   <g id="edge2" class="edge"><title>(a &amp; b) |&#45; a&#45;&#45;a, b |&#45; a</title>
     <path style="fill:none;stroke:black;" d="M43,-88C43,-73 43,-51 43,-36"/>
     <a xlink:title="&amp;&#45;Left">
     </a>
     <a xlink:title="&amp;&#45;Left">
     </a>
     <text text-anchor="middle" x="62" y="-56" style="font-family:Nimbus Roman No9 L;font-weight:regular;font-size:11.34pt;">&amp;&#45;Left</text>
   </g>
 
 </g>
 
 </svg> 
 '
 
   return svg_str
  end
  

 end