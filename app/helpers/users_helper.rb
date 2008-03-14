module UsersHelper
  def user_form_fields(form)
    labeled_input 'Name', :for => :name do
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