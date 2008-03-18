module ServicesHelper
  def service_form_fields(form)
    markaby do
      labeled_input 'Service type', :for => :service_type_id do
        @service_types = ServiceType.find_all.map { |type| [type.name, type.id]}
        form.select(:service_type_id, @service_types)
      end
      labeled_input 'Start date', :for => :start_date do
        form.date_select :start_date
      end
      labeled_input 'End date', :for => :end_date do
        form.date_select :end_date
      end
      labeled_input 'Paid', :for => :paid do
        form.check_box :paid
      end
      labeled_input 'Volunteered', :for => :volunteered do
        form.check_box :volunteered
      end
      fields_for :note do |note|
        labeled_input 'Note', :for => :visit_note do
          note.text_area :text, :rows => 6
        end
      end
    end
  end
end
