module OrganizationsHelper
  def organization_form_fields(form)
    markaby do
      labeled_input 'Name', :for => :name do
        form.text_field :name
      end
      labeled_input 'Key', :for => :key do
        form.text_field :key
      end
      labeled_input 'Timezone', :for => :timezone do
        time_zone_select :organization, :timezone
      end
    end
  end
end
