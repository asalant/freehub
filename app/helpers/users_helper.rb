module UsersHelper
  
  def user_status
    markaby do
      div.user_status! do
        if logged_in?
          text "Logged in as #{link_to current_user.login, edit_user_path(current_user)}"
          text "&nbsp;|&nbsp;"
          link_to 'Log out', session_path, :method => :delete
        else
          link_to 'Log in', new_session_path
        end
      end
    end
  end

  def userstamp_labeled_values(model)
      [labeled_value('Created', "#{datetime_short(model.created_at)} by #{user_link(model.created_by)}"),
       labeled_value('Updated', "#{datetime_short(model.updated_at)} by #{user_link(model.updated_by)}")].join
  end

  def user_link(user)
    link_to(user.login, user_path(user)) if user
  end

  def user_form_fields(form)
    markaby do
      labeled_input 'Full Name', :for => :name do
        form.text_field :name
      end
      labeled_input 'Email', :for => :email do
        form.text_field :email
      end
      labeled_input 'Login', :for => :login do
        form.text_field :login
      end
      labeled_input 'Password', :for => :password do
        form.password_field :password
      end
      labeled_input 'Confirm Password', :for => :password_confirmation do
        form.password_field :password_confirmation
      end
    end
  end
end