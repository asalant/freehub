# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ApplicationHelper

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4053cfc52c7349828c17880e0b762667'

  # Include restful_authentication support
  include AuthenticatedSystem
  include UrlHelper

  # Authenticate
  before_filter :login_from_cookie, :login_required, :store_current_user

  # Root object for nested resources
  before_filter :resolve_organization, :resolve_person

  # Timezone of the organization or default
  before_filter :set_timezone

  private

  def resolve_organization
    @organization = Organization.find_by_key(params[:organization_key])
  end

  def resolve_person
    @person = Person.find(params[:person_id]) if params[:person_id]
  end

  def store_current_user
    User.current_user = current_user
  end

  def set_timezone
    Time.zone =  @organization ? @organization.timezone : ENV['TIMEZONE_DEFAULT']
  end

  # year, month, day
  def date_from_params(params)
    return nil unless params[:year] && params[:month] && params[:day]
    Date.new params[:year].to_i, params[:month].to_i, params[:day].to_i
  end

  def user_is_admin_or_manager?
    is_user_in_organization? && ( @current_user.roles.first.name == "admin" || @current_user.roles.first.name == "manager")
  end

  def authorize_admin_or_manager
    redirect_unauthrized unless user_is_admin_or_manager? 
  end

  def redirect_unauthrized
    redirect_to({ :controller => 'sessions', :action => 'new' })
  end
  
  def authorize_admin
    redirect_unauthrized unless user_is_admin?
  end

  def user_is_admin?
    is_user_in_organization? && @current_user.roles.first.name == "admin"
  end
  
  def is_user_in_organization?
    user_organization = @current_user.organization
    if user_organization.nil? || @organization.nil?
      return false
    end 
    @current_user.organization.id == @organization.id 
  end
end

