module ServicesHelper
  def service_form_fields(form)
    markaby do
      labeled_input 'Service type', :for => :service_type_id do
        @service_types = ServiceType.find_all.map { |type| [type.name, type.id]}
        form.select(:service_type_id, @service_types)
      end
      labeled_input 'Start date', :for => :start_date do
        calendar_date_select_tag "service[start_date]", @service[:start_date], :year_range => 5.years.ago..1.years.from_now
      end
      labeled_input 'End date', :for => :end_date do
        calendar_date_select_tag "service[end_date]", @service[:end_date], :year_range => 4.years.ago..2.years.from_now
      end
      labeled_input 'Paid', :for => :paid do
        form.check_box :paid
      end
      labeled_input 'Volunteered', :for => :volunteered do
        form.check_box :volunteered
      end
      fields_for :note, @service.note do |note|
        labeled_input 'Note', :for => :visit_note do
          note.text_area :text, :rows => 6
        end
      end
    end
  end
end
