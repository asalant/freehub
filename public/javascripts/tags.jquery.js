(function($)
{
    $.fn.tags_control = function()
    {

        return $(this).each(function()
        {
            var tags_control = this;
            
            $('.view', tags_control).show();
            $('.edit', tags_control).hide();

            $('.view a.show_edit', this).bind('click', function()
            {
                $('.view', tags_control).hide();
                $('.edit', tags_control).show();
                return false;
            });

            $('.edit a.show_view', this).bind('click', function()
            {
                $('.view', tags_control).show();
                $('.edit', tags_control).hide();
                return false;
            });
        });
    }
})(jQuery);