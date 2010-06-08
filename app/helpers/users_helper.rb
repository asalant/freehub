module UsersHelper

  def userstamp_labeled_values(model)
      [labeled_value('Created', "#{datetime_short(model.created_at)} by #{user_link(model.created_by)}"),
       labeled_value('Updated', "#{datetime_short(model.updated_at)} by #{user_link(model.updated_by)}")].join
  end

  def user_link(user)
    link_to(user.login, user_path(user)) if user
  end

end