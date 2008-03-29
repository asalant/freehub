# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def breadcrumb(*items)
    items.join ' : '
  end

  def time_short(datetime)
    datetime.strftime("%I:%M %p") if datetime
  end

  def datetime_short(datetime)
    datetime.to_s(:db) if datetime
  end

  def datetime_long(datetime)
    datetime.strftime("%a %b %d %Y %I:%M %p") if datetime
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

  def sign_in_today_path(options={})
    sign_in_path({:year => Date.today.year, :month => Date.today.month, :day => Date.today.day}.merge(options))
  end
end
