(function($)
{
    $.fn.tags_control = function()
    {

        return $(this).each(function()
        {
            var tag_control = this;
            var view_control = $('.view', tag_control);
            var edit_control = $('.edit', tag_control);

            view_control.each(function()
            {
                $('a.show_edit', this).bind('click', function()
                {
                    view_control.hide();
                    edit_control.show();
                    return false;
                });
            });

            edit_control.each(function()
            {
                $(this).hide();
                $('.all', this).hide();
                $('a.show_view', this).bind('click', function()
                {
                    view_control.show();
                    edit_control.hide();
                    return false;
                });
            });
        });
    }
})(jQuery);