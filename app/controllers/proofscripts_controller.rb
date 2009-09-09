class ProofscriptsController < ApplicationController
  
  # GET /proofscripts
  # GET /proofscripts.xml
  def index
    @proofscripts = Proofscript.find_all_by_user_id(session[:user_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proofscripts }
    end
  end

  # GET /proofscripts/1
  # GET /proofscripts/1.xml
  def show
    @proofscript = Proofscript.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proofscript }
    end
  end

  # GET /proofscripts/new
  # GET /proofscripts/new.xml
  def new
    @proofscript = Proofscript.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proofscript }
    end
  end

  # GET /proofscripts/1/edit
  def edit
    @proofscript = Proofscript.find(params[:id])
  end

  # POST /proofscripts
  # POST /proofscripts.xml
  def create
    @proofscript = Proofscript.new(params[:proofscript])
    @proofscript.user = User.find(session[:user_id])

    respond_to do |format|
      if @proofscript.save
        flash[:notice] = 'Proofscript was successfully created.'
        format.html { redirect_to(@proofscript) }
        format.xml  { render :xml => @proofscript, :status => :created, :location => @proofscript }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @proofscript.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /proofscripts/1
  # PUT /proofscripts/1.xml
  def update
    @proofscript = Proofscript.find(params[:id])

    respond_to do |format|
      if @proofscript.update_attributes(params[:proofscript])
        flash[:notice] = 'Proofscript was successfully updated.'
        format.html { redirect_to(@proofscript) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @proofscript.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /proofscripts/1
  # DELETE /proofscripts/1.xml
  def destroy
    @proofscript = Proofscript.find(params[:id])
    @proofscript.destroy

    respond_to do |format|
      format.html { redirect_to(proofscripts_url) }
      format.xml  { head :ok }
    end
  end
end
