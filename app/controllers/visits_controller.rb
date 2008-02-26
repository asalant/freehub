class VisitsController < ApplicationController
  # GET /visits
  # GET /visits.xml
  def index
    @visits = Visit.for_person(@person).paginated(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @visits }
    end
  end

  # GET /visits/1
  # GET /visits/1.xml
  def show
    @visit = Visit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @visit }
    end
  end

  # GET /visits/new
  # GET /visits/new.xml
  def new
    @visit = Visit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @visit }
    end
  end

  # GET /visits/1/edit
  def edit
    @visit = Visit.find(params[:id])
  end

  # POST /visits
  # POST /visits.xml
  def create
    @visit = Visit.new(params[:visit])
    @visit.person = @person

    respond_to do |format|
      if @visit.save
        flash[:notice] = 'Visit was successfully created.'
        format.html { redirect_to(visit_path(:id => @visit)) }
        format.xml  { render :xml => @visit, :status => :created, :location => @visit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @visit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /visits/1
  # PUT /visits/1.xml
  def update
    @visit = Visit.find(params[:id])

    respond_to do |format|
      if @visit.update_attributes(params[:visit])
        flash[:notice] = 'Visit was successfully updated.'
        format.html { redirect_to(visit_path(:id => @visit)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @visit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /visits/1
  # DELETE /visits/1.xml
  def destroy
    @visit = Visit.find(params[:id])
    @visit.destroy

    respond_to do |format|
      format.html { redirect_to(visits_url) }
      format.xml  { head :ok }
    end
  end
end
