class OrganizationsController < ApplicationController

  skip_before_filter :login_required, :only => [:index, :show, :new, :create]
  before_filter :assign_id_param, :resolve_organization_by_id, :authorize_admin_or_manager, :except => [ :index, :new, :create ] 
  before_filter :authorize_admin, :only => [ :destory ]

  # GET /organizations
  # GET /organizations.xml
  def index
    @organizations = Organization.find(:all, :order => 'name ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organizations }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization }
    end
  end

  # GET /organizations/new
  # GET /organizations/new.xml
  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization }
    end
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.xml
  def create
    @organization = Organization.new(params[:organization])
    @user = User.new(params[:user])

    respond_to do |format|
      if @organization.valid? && @user.valid? && @organization.save && @user.save
        @user.has_role 'manager', @organization
        self.current_user = @user
        flash[:notice] = 'Organization was successfully created.'
        format.html { redirect_to @organization }
        format.xml  { render :xml => @organization, :status => :created, :location => @organization }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.xml
  def update
    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        flash[:notice] = 'Organization was successfully updated.'
        format.html { redirect_to @organization }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.xml
  def destroy
    @organization.destroy
    flash[:notice] = 'Organization was successfully removed.'

    respond_to do |format|
      format.html { redirect_to(organizations_url) }
      format.xml  { head :ok }
    end
  end

  private

  def resolve_organization_by_id
    @organization = Organization.find(params[:id]) if params[:id]
  end

  def assign_id_param
    params[:id] ||= @organization.id if @organization
  end
end
