# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def organization_header(organization)
    markaby do
      h1.organization_header! do
        link_to organization.name, organization_path(:id => organization)
        text " on Freehub"
        end
      div.organization_nav! do
          link_to('Visits', :controller => 'reports', :action => 'visits', :organization_key => @organization.key)
          text ' | '
          link_to('People', people_path(:organization_key => organization.key))
          text ' | Find person: '
          text_field_with_auto_complete :person, :full_name, { :onfocus => "this.select()" },
                  :url => auto_complete_for_person_full_name_people_path(:organization_key => organization.key) ,
                  :method => :get, :min_chars => 2,
                  :indicator => 'search_status',
                  :after_update_element => <<END
function(element, value) {
  window.location = '#{people_path(:organization_key => organization.key)}/' + value.id;
}
END
        image_tag 'spinner.gif', :id => 'search_status', :style => 'display:none;'  
      end
    end
  end

  def user_status(user)
    markaby do
      div.user_status! do
        text "Logged in as #{link_to current_user.login, edit_user_path(user)}"
        text "&nbsp;|&nbsp;"
        link_to 'Logout', session_path, :method => :delete
      end
    end
  end
  
  def datetime_short(datetime)
    datetime.strftime("%a %b %d %Y %I:%M %p")
  end
end
