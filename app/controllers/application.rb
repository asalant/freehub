# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4053cfc52c7349828c17880e0b762667'

  # Include restful_authentication support
  include AuthenticatedSystem

  # Authenticate
  before_filter :login_from_cookie, :login_required, :store_current_user

  # Root object for nested resources
  before_filter :resolve_organization, :resolve_person

  # Timezone of the organization or default
  before_filter :set_timezone

  private

  def resolve_organization
    @organization = Organization.find_by_key(params[:organization_key]) if params[:organization_key]
  end

  def resolve_person
    @person = Person.find(params[:person_id]) if params[:person_id]
  end

  def store_current_user
    User.current_user = current_user
  end

  def set_timezone
    TzTime.zone =  @organization ? TimeZone[@organization.timezone] : TimeZone[ENV['TIMEZONE_DEFAULT']]
  end

end
