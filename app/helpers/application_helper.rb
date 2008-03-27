# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def breadcrumb(*items)
    items.join ' : '
  end
  
  def organization_header(organization)
    markaby do
      h2.organization_header! do
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

  def user_status
    markaby do
      div.user_status! do
        if logged_in?
          text "Logged in as #{link_to current_user.login, edit_user_path(current_user)}"
          text "&nbsp;|&nbsp;"
          link_to 'Log out', session_path, :method => :delete
        else
          link_to 'Log in', new_session_path
        end
      end
    end
  end

  def userstamp_labeled_values(model)
    markaby do
      labeled_value 'Created', "#{datetime_short(model.created_at)} by #{user_link(model.created_by)}"
      labeled_value 'Updated', "#{datetime_short(model.updated_at)} by #{user_link(model.updated_by)}"
    end
  end

  def user_link(user)
    link_to(user.login, user_path(user)) if user
  end

  def time_short(datetime)
    datetime.strftime("%I:%M %p") if datetime
  end

  def datetime_short(datetime)
    datetime.to_s(:db) if datetime
  end

  def datetime_long(datetime)
    datetime.strftime("%a %b %d %Y %I:%M %p") if datetime
  end

  def date_long(date)
    date.strftime("%a %B %d %Y") if date
  end

  def date_short(date)
    date.to_s(:db) if date
  end

  # Override ActionView::Helpers::DateHelper#time_ago_in_words to handle timezone conversions
  def time_ago_in_words(from_time, include_seconds=false)
    distance_of_time_in_words(from_time, TzTime.now, include_seconds)
  end

  def signin_today_path(options={})
    signin_path({:year => Date.today.year, :month => Date.today.month, :day => Date.today.day}.merge(options))
  end
end
