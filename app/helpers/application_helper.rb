# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def markaby1(&block)
    Markaby::Builder.new({}, self, &block)
  end

  def markaby(&proc)
   assigns = {}
   instance_variables.each do |name|
     assigns[ name[1..-1] ] =  instance_variable_get(name)
    end
   Markaby::Builder.new(assigns, self).capture(&proc)
  end


  def string_path(string)
    string
  end

  def labeled_input(label_value, attributes={}, &block)
    markaby do
      p do
        label label_value, attributes
        br
        markaby(&block)
      end
    end
  end
end
