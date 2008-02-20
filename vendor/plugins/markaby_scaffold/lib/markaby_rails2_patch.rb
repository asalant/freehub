# This monkey patch fixes an exception specific to Rails 2.0.2
module ActionView # :nodoc:
  class Base # :nodoc:
   def render_template_with_markaby_line_support(template_extension, template, file_path = nil, local_assigns = {})
     handler = self.class.handler_for_extension(template_extension)

     if (handler == Markaby::Rails::ActionViewTemplateHandler)
        template ||= read_template_file(file_path, template_extension)
        handler.new(self).render(template, local_assigns, file_path)
      else
       render_template_without_markaby_line_support(template_extension, template, file_path, local_assigns)
      end
    end

   alias_method_chain :render_template, :markaby_line_support
  end
end