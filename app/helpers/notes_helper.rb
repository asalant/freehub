module NotesHelper


  def notable_link(model)
    if model.is_a? Visit
      link_to notable_label(model), visit_path(:person_id => @person, :id => model)
    elsif model.is_a? Person
      link_to notable_label(model), person_path(:id => model)
    elsif model.is_a? Service
      link_to notable_label(model), service_path(:person_id => @person, :id => model)
    end
  end

  def notable_label(model)
    if model.is_a? Visit
      "Visit on #{date_long(model.datetime)}"
    elsif model.is_a? Person
      "Person named #{model.full_name}"
    elsif model.is_a? Service
      "#{ServiceType[model.service_type_id].name} ending #{date_long(model.end_date)}"
    end
  end
end
