(function($)
{
    $.fn.tags_edit = function()
    {

        return $(this).each(function()
        {
            $('.tags_all', this).hide();
        });
    };
})(jQuery);