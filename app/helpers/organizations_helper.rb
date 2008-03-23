module OrganizationsHelper
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
