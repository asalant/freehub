module VisitsHelper
  def visit_form_fields(form)
    markaby do
      labeled_input 'Datetime', :for => :visit_datetime do
        form.datetime_select :datetime
      end
      labeled_input 'Volunteer', :for => :visit_volunteer do
        form.check_box :volunteer
      end
      fields_for :note do |note|
        labeled_input 'Note', :for => :visit_note do
          note.text_area :text, :rows => 6
        end
      end
    end
  end
end
