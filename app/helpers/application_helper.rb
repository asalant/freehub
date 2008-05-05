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
    date_long(datetime) + time_short(datetime) if datetime
  end

  def date_long(date)
    date.strftime("%a %B %d %Y") if date
  end

  def date_short(date)
    date.to_s(:db) if date
  end

  # Override ActionView::Helpers::DateHelper#time_ago_in_words to handle timezone conversions
  def time_ago_in_words(from_time, include_seconds=false)
    distance_of_time_in_words(from_time, TzTime.now, include_seconds)
  end

  def tab_item(label, path)
    markaby do
      li(:class => request.path == path ? 'selected' : '') { link_to label, path }
    end
  end

  def today_visits_path(params={})
    today = Date.today
    day_visits_path params.merge(:year => today.year, :month => today.month, :day => today.day)
  end
end
