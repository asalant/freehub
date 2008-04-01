module PeopleHelper

  def person_form_fields(form)
    markaby do
      div.column do
        labeled_input 'First name', :for => :first_name do
          form.text_field :first_name
        end
        labeled_input 'Last name', :for => :last_name do
          form.text_field :last_name
        end
        labeled_input 'Staff', :for => :staff do
          form.check_box :staff
        end
        labeled_input 'Email', :for => :email do
          form.text_field :email
        end
        labeled_input 'Email opt out', :for => :email_opt_out do
          form.check_box :email_opt_out
        end
        labeled_input 'Phone', :for => :phone do
          form.text_field :phone
        end
      end
      div.column do
        labeled_input 'Street1', :for => :street1 do
          form.text_field :street1
        end
        labeled_input 'Street2', :for => :street2 do
          form.text_field :street2
        end
        labeled_input 'City', :for => :city do
          form.text_field :city
        end
        labeled_input 'State', :for => :state do
          form.text_field :state
        end
        labeled_input 'Postal code', :for => :postal_code do
          form.text_field :postal_code
        end
        labeled_input 'Country', :for => :country do
          form.text_field :country
        end
      end
    end
  end

  # See vendor/plugins/auto_complete/lib/auto_complete_macros_helper.rb
  def auto_complete_result_with_add_person(entries, field, phrase = nil)
    return unless entries
    items = entries.map do |entry|
      content_tag("li", phrase ? highlight(entry[field], phrase) : h(entry[field]),
          :url => person_path(:organization_key => @organization.key, :id => entry.id))
    end
    items << content_tag("li", content_tag("b", 'Add Person'),
        :url => new_person_path(:organization_key => @organization.key))
    content_tag("ul", items.uniq)
  end

  def sign_in_form_fields(form)
    markaby do
      hidden_field_tag :destination, sign_in_today_path
      fields_for :note do |note|
        labeled_input 'Note', :for => :visit_note do
          note.text_area :text, :rows => 2
        end
      end
      labeled_input 'Volunteer', :for => :visit_volunteer do
        form.check_box :volunteer
      end
      labeled_input '-' do
        form.submit "Sign In!"
      end
    end
  end

end
