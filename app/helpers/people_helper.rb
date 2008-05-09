module PeopleHelper

  def person_form_fields(form)
    markaby do
      div.section do
        div.column.left do
          ul do
            labeled_input 'Name', :required => true, :for => 'person_first_name' do
              span do
                text form.text_field(:first_name, :class => 'text short')
                label 'First', :for => 'person_first_name'
              end
              span do
                text form.text_field(:last_name, :class => 'text short')
                label 'Last', :for => 'person_last_name'
              end
            end
            labeled_input 'Email', :for => :person_email do
              span do
                text form.text_field(:email, :class => 'text short')
              end
              span do
                text form.check_box(:email_opt_out, :class => 'checkbox')
                label.choice "Don't send emails", :for => 'person_email_opt_out'
              end
            end
            labeled_input 'Phone Number', :for => :person_phone do
              form.text_field(:phone, :class => 'text short')
            end
            labeled_input 'Role' do
              text form.radio_button(:staff, false, :class => 'radio')
              label.choice 'Patron', :for => 'person_staff_false'
              text form.radio_button(:staff, true, :class => 'radio')
              label.choice 'Staff', :for => 'person_staff_true'
            end
            li { form.submit @person.new_record? ? "Create" : "Update" }
          end
        end
        div.column do
          ul do
            labeled_input 'Address' do
              div do
                text form.text_field(:street1, :class => 'text medium')
                label 'Street Address'
              end
              div do
                text form.text_field(:street2, :class => 'text medium')
                label 'Address Line 2'
              end
              span do
                text form.text_field(:city, :class => 'text short')
                label 'City', :for => 'person_city'
              end
              span do
                text form.text_field(:state, :class => 'text short')
                label 'State / Province / Region', :for => 'person_state'
              end
              span do
                text form.text_field(:postal_code, :class => 'text short')
                label 'Postal / Zip Code', :for => 'person_postal_code'
              end
              span do
                text form.text_field(:country, :class => 'text short')
                label 'Country', :for => 'person_country'
              end
            end
            userstamp_labeled_values(@person) if !@person.new_record?
          end
        end
      end
    end
  end

  def labeled_input(label_value, attributes={}, &block)
    markaby do
      li do
        required = attributes.delete(:required)
        label.desc attributes do
          text label_value
          span.req '*' if required
        end
        markaby(&block)
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
      hidden_field_tag :destination, today_visits_path
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
