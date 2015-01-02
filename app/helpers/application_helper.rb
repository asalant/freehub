# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def breadcrumb(*items)
    items.join ' : '
  end

  def time_short(datetime)
    datetime.strftime("%I:%M %p").gsub(/^0/,'').downcase if datetime
  end

  def datetime_short(datetime)
    datetime.strftime("%Y-%m-%d %H:%M") if datetime
  end

  def datetime_long(datetime)
    "#{date_long(datetime)} #{time_short(datetime)}" if datetime
  end

  def date_long(date)
    date.strftime("%a %b %d %Y") if date
  end

  def date_short(date)
    date.strftime("%d-%b-%y") if date
  end

  # Override ActionView::Helpers::DateHelper#time_ago_in_words to handle timezone conversions
  def time_ago_in_words(from_time, include_seconds=false)
    distance_of_time_in_words(from_time, Time.zone.now, include_seconds)
  end

  def tab_item(label, path)
    "<li class='#{request.path == path ? 'selected' : ''}'><a href='#{path}'>#{label}</a></li>"
  end

  def today_visits_path(params={})
    today = Date.today
    day_visits_path params.merge(:year => today.year, :month => today.month, :day => today.day)
  end


  # View helpers migrated from Markaby
  #TODO: figure out a cleaner way to do this with HAML
  def labeled_input(label_value, attributes={}, &block)
    Haml::Engine.new(<<EOL
%li
  -required = attributes.delete(:required)
  %label.desc{attributes}
    =label_value
    -if required
      %span.req *
  =block.call if block
EOL
    ).render(self, :label_value => label_value, :attributes => attributes, :block => block)
  end

  def labeled_value(label_value, value)
    Haml::Engine.new(<<EOL
%li
  .label= label_value
  .value= value
EOL
    ).render(self, :label_value => label_value, :value => value)
  end

  def user_is_manager?
    wrapped_current_user.try(:is_manager_of?, @organization)
  end

  def user_is_admin?
    wrapped_current_user.try(:is_admin?)
  end

  def wrapped_current_user
    User.current_user if User.current_user != :false
  end
end
