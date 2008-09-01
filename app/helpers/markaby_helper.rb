module MarkabyHelper
  
  # Markaby helper for model input fields (new, edit)
  def labeled_input(label_value, attributes={}, &block)
    markaby do
      li do
        required = attributes.delete(:required)
        label.desc attributes do
          text label_value
          span.req ' *' if required
        end
        markaby(&block)
      end
    end
  end

  # Markaby helper for model values (show)
  def labeled_value(label_value, value)
    markaby do
      li do
        div.label { "#{label_value} " }
        div.value { text value }
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
