module MarkabyHelper
  
  # Markaby helper for model input fields (new, edit)
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

  # Markaby helper for model values (show)
  def labeled_value(label_value, value)
    Haml::Engine.new(<<EOL
%li
  .label= label_value
  .value= value
EOL
    ).render(self, :label_value => label_value, :value => value)
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
