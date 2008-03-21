class UsersController < ApplicationController

  before_filter :resolve_user_by_id
  skip_before_filter :login_from_cookie, :login_required, :only => [:new, :create, :activate, :reset, :forgot]

  permit "admin", :only => [:index]
  permit "admin or (owner of :user)", :only => [:edit, :update, :destroy]
  
  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default(welcome_user_path(self.current_user))
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default(welcome_user_path(self.current_user))
  end

  def forgot
    if request.post?
      @user = User.find_by_email(params[:user][:email]) || User.new
      if !@user.new_record?
        @user.create_reset_code
        flash[:notice] = "Reset code sent to #{@user.email}"
        redirect_to new_session_path
      else
        flash[:notice] = "#{params[:user][:email]} does not exist in system"
      end
    else
      @user = User.new
    end
  end

  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if request.post?
      if @user.reset_password(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        self.current_user = @user
        flash[:notice] = "Password reset successfully for #{@user.email}"
        redirect_to user_path(:id => @user)
      else
        render :action => :reset
      end
    end
  end

  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /organizations/1/welcome
  def welcome
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  private

  def resolve_user_by_id
    @user = params[:id] ? User.find(params[:id]) : nil
    @organization = @user.is_manager_for_what[0] if @user && @user.is_manager_for_what[0]
  end
end
