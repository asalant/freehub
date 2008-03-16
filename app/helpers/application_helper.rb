# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def breadcrumb(*items)
    items.join ' : '
  end
  def organization_header(organization)
    markaby do
      h1.organization_header! do
        link_to organization.name, organization_key_path(:organization_key => organization.key)
        text ' on '
        link_to 'Freehub', root_path
        end
      div.organization_nav! do
        b 'Report: '
        link_to('Visits', report_path(:action => 'visits', :organization_key => @organization.key))
        text ' | '
        link_to('Services', report_path(:action => 'services', :organization_key => @organization.key))
        text ' | '
        link_to('People', report_path(:action => 'people', :organization_key => @organization.key))
        text ' | '
        b 'Visits: '
        link_to('Today', signin_today_path(:organization_key => @organization.key))
        text ' | '
        b 'People: '
        link_to('Add', new_person_path(:organization_key => organization.key))
        text ' | Find: '
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

  def time_short(datetime)
    datetime.strftime("%I:%M %p")
  end

  def datetime_short(datetime)
    datetime.strftime("%a %b %d %Y %I:%M %p")
  end

  def date_long(date)
    date.strftime("%a %B %d %Y")
  end

  def date_short(date)
    date.to_s(:db)
  end

  def signin_today_path(options={})
    signin_path({:year => Date.today.year, :month => Date.today.month, :day => Date.today.day}.merge(options))
  end
end
