module OrganizationsHelper

  def organization_header(organization)
    markaby do
      h2.organization_header! do
        link_to organization.name, organization_key_path(:organization_key => organization.key)
        text ' on '
        link_to 'Freehub', root_path
        end
      div.organization_nav! do
        b 'Report: '
        link_to('Visits', report_path(:action => 'visits', :organization_key => organization.key))
        text ' | '
        link_to('Services', report_path(:action => 'services', :organization_key => organization.key))
        text ' | '
        link_to('People', report_path(:action => 'people', :organization_key => organization.key))
        text ' | '
        b 'Visits: '
        link_to('Today', sign_in_today_path(:organization_key => organization.key))
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
  window.location = $(value).readAttribute('url');
}
END
        image_tag 'spinner.gif', :id => 'search_status', :style => 'display:none;'
      end
    end
  end

  def organization_form_fields(form)
    markaby do
      labeled_input 'Name', :for => :name do
        text form.text_field(:name)
        span.instructions "e.g. San Francisco Bike Kitchen"
      end
      labeled_input 'Key', :for => :key do
        text form.text_field(:key)
        span.instructions "e.g. sfbk, used for URL http://freehub.bikekitchen.org/sfbk"
      end
      labeled_input 'Timezone', :for => :timezone do
        time_zone_select :organization, :timezone
      end
    end
  end
end
