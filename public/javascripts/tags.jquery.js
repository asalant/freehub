(function($)
{
    $.fn.tags_control = function()
    {

        return $(this).each(function()
        {
            var tags_control = $(this);

            $('.view', this).show();
            $('.edit', this).hide();

            $('.view a.show_edit', this).live('click', function()
            {
                $('.view', tags_control).hide();
                $('.edit', tags_control).show();
                return false;
            });

            $('.edit a.show_view', this).live('click', function()
            {
                $('.view', tags_control).show();
                $('.edit', tags_control).hide();
                return false;
            });

            $('.edit a.delete').live('click', function (event)
            {
                tags_control.trigger('delete', { url: $(this).attr('href') });
                event.preventDefault();
            });

            $('select', this).live('change', function(event)
            {
                if ($(this).val() != '')
                {
                    tags_control.trigger('add', { url: $(this).parent('form').attr('action'), tag: $(this).val() });
                }
            });

            tags_control.bind('delete', function(event, data)
            {
                tags_control.addClass('ajax_loading');
                $.ajax({
                    type: 'POST',
                    url: data.url,
                    data: { _method: 'DELETE', auth_token: window.AUTHENTICITY_TOKEN},
                    success: function(data, status)
                    {
                        tags_control.replaceWith(data);
                    }
                });
                return data;
            });


            tags_control.bind('add', function(event, data)
            {
                tags_control.addClass('ajax_loading');
                $.ajax({
                    type: 'POST',
                    url: data.url,
                    data: { _method: 'POST', auth_token: window.AUTHENTICITY_TOKEN, id: data.tag },
                    success: function(data, status)
                    {
                        tags_control.replaceWith(data);
                    }
                });
                return data;
            });
        });
    }
})(jQuery);