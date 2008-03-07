class ServiceTypesController < ApplicationController
  
  permit 'admin'
  
  # GET /service_types
  # GET /service_types.xml
  def index
    @service_types = ServiceType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_types }
    end
  end

  # GET /service_types/1
  # GET /service_types/1.xml
  def show
    @service_type = ServiceType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_type }
    end
  end

  # GET /service_types/new
  # GET /service_types/new.xml
  def new
    @service_type = ServiceType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_type }
    end
  end

  # GET /service_types/1/edit
  def edit
    @service_type = ServiceType.find(params[:id])
  end

  # POST /service_types
  # POST /service_types.xml
  def create
    @service_type = ServiceType.new(params[:service_type])

    respond_to do |format|
      if @service_type.save
        flash[:notice] = 'ServiceType was successfully created.'
        format.html { redirect_to(@service_type) }
        format.xml  { render :xml => @service_type, :status => :created, :location => @service_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /service_types/1
  # PUT /service_types/1.xml
  def update
    @service_type = ServiceType.find(params[:id])

    respond_to do |format|
      if @service_type.update_attributes(params[:service_type])
        flash[:notice] = 'ServiceType was successfully updated.'
        format.html { redirect_to(@service_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_types/1
  # DELETE /service_types/1.xml
  def destroy
    @service_type = ServiceType.find(params[:id])
    @service_type.destroy

    respond_to do |format|
      format.html { redirect_to(service_types_url) }
      format.xml  { head :ok }
    end
  end
end
