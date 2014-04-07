module PeopleHelper

  # See vendor/plugins/auto_complete/lib/auto_complete_macros_helper.rb
  def auto_complete_result_with_add_person(entries, field, phrase = nil)
    return unless entries
    items = entries.map do |entry|
      content_tag("li", phrase ? highlight(entry[field], phrase) : h(entry[field]),
          :class => 'person',
          :url => person_path(:organization_key => @organization.key, :id => entry.id))
    end
    items << content_tag("li", content_tag("b", 'Add Person'),
        :class => 'add',
        :url => new_person_path(:organization_key => @organization.key))
    content_tag("ul", items.uniq.join(''))
  end

end
