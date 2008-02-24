# This monkey patch fixes an exception specific to Rails 2.0.2 by replacing the definition of
# ActionView::Base#render_template that Markaby overrides in markaby/rails.rb with the original
# definition from Rails at http://svn.rubyonrails.org/rails/tags/rel_2-0-2/actionpack/lib/action_view/base.rb
module ActionView # :nodoc:
  class Base # :nodoc:
    # Renders the +template+ which is given as a string as either erb or builder depending on <tt>template_extension</tt>.
    # The hash in <tt>local_assigns</tt> is made available as local variables.
    def render_template(template_extension, template, file_path = nil, local_assigns = {}) #:nodoc:
      handler = self.class.handler_for_extension(template_extension)

      if template_handler_is_compilable?(handler)
        compile_and_render_template(handler, template, file_path, local_assigns)
      else
        template ||= read_template_file(file_path, template_extension) # Make sure that a lazyily-read template is loaded.
        delegate_render(handler, template, local_assigns)
      end
    end
  end
end

# Changes Markaby::Rails::ActionViewTemplateHandler#render to make file_path optional
module Markaby
  module Rails
    class ActionViewTemplateHandler # :nodoc:
      def initialize(action_view)
        @action_view = action_view
      end
      def render(template, local_assigns, file_path=nil)
        template = Template.new(template)
        template.path = file_path
        template.render(@action_view.assigns.merge(local_assigns), @action_view)
      end
    end
  end
end