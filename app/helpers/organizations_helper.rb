module OrganizationsHelper

  def organization_header(organization)
    markaby do
      h2.organization_header! do
        link_to organization.name, organization_key_path(:organization_key => organization.key)
        text ' on '
        link_to 'Freehub', root_path
        end
      div.organization_nav! do
        link_to('Sign In', sign_in_today_path(:organization_key => organization.key))
        text ' | '
        link_to('Reports', report_path(:action => 'index', :organization_key => organization.key))
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
