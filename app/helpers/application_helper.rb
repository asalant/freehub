# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def datetime_short(datetime)
    datetime.strftime("%a %b %d %Y %I:%M %p")
  end
end
