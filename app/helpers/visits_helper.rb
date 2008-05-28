module VisitsHelper
  def visit_form_fields(form)
    markaby do
      ul do
        labeled_input 'Datetime', :for => :visit_datetime do
          calendar_date_select_tag "visit[datetime]", @visit.datetime, :time => true, :year_range => 3.years.ago..0.years.from_now
        end
        labeled_input 'Volunteer', :for => :visit_volunteer do
          form.check_box :volunteer
        end
        fields_for :note, @visit.note do |note|
          labeled_input 'Note', :for => :visit_note do
            note.text_area :text, :rows => 6
          end
        end
        li { form.submit @visit.new_record? ? "Create" : "Update" }
      end
    end
  end

  def sign_in_search_panel
    markaby do
      div.section.sign_in! do
        h2 "Sign A Person In"
        div.form do
          label.desc 'Name', :style => 'float:left;'
          image_tag 'spinner.gif', :id => 'search_status', :style => 'display:none;'
          text_field_with_auto_complete :person, :full_name, { :onfocus => "this.select()" },
                  :url => auto_complete_for_person_full_name_people_path(:organization_key => organization.key) ,
                  :method => :get, :min_chars => 2,
                  :indicator => 'search_status',
                  :after_update_element => <<-END
          function(element, value) {
            window.location = $(value).readAttribute('url');
          }
          END
        p { "Start typing to find a person in the system or #{link_to "add a new person", new_person_path}." }
        end
        script "$('person_full_name').focus();", :type => 'text/javascript'
      end
    end
  end
end
