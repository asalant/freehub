module MarkabyHelper

  def organization_header(organization)
    markaby do
      h1.organization_header! do
        link_to @organization.name, organization_path(:id => @organization)
        text " on Freehub"
      end
    end
  end

  def user_status(user)
    markaby do
      div.user_status! do
        text "Logged in as #{link_to current_user.login, edit_user_path(user)}"
        text "&nbsp;|&nbsp;"
        link_to 'Logout', session_path, :method => :delete
      end
    end
  end
  
  # Markaby helper for model input fields (new, edit)
  def labeled_input(label_value, attributes={}, &block)
    markaby do
      p do
        label label_value, attributes
        br
        markaby(&block)
      end
    end
  end

  # Markaby helper for model values (show)
  def labeled_value(label_value, value)
    markaby do
      p do
        b label_value + ': '
        text value
      end
    end
  end

  # Use markaby in helpers with this method
  def markaby(&proc)
   assigns = {}
   instance_variables.each do |name|
     assigns[ name[1..-1] ] =  instance_variable_get(name)
    end
   Markaby::Builder.new(assigns, self).capture(&proc)
  end

  # Prevents having to use to_s for some generated paths in templates
  def string_path(string)
    string
  end

end
