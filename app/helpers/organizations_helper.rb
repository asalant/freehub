module OrganizationsHelper

  def organization_form_fields(form)
    markaby do
      labeled_input 'Organization Name', :for => :name do
        div { form.text_field(:name) }
        p.instruct "For example 'San Francisco Bike Kitchen'"
      end
      labeled_input 'Key', :for => :key do
        div { form.text_field(:key) }
        p.instruct "For example 'sfbk', used for URL http://freehub.bikekitchen.org/sfbk"
      end
      labeled_input 'Timezone', :for => :timezone do
        time_zone_select :organization, :timezone
      end
    end
  end
end
