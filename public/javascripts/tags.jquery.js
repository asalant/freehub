(function($)
{
    $.fn.tags_control = function()
    {

        return $(this).each(function()
        {
            var tags_control = $(this);
            var context = tags_control.parent()[0];

            $('.view', this).show();
            $('.edit', this).hide();

            $('.view a.show_edit', context).bind('click', function(event)
            {
                $('.view', tags_control).hide();
                $('.edit', tags_control).show();
                event.preventDefault();
            });

            $('.edit a.show_view', context).bind('click', function(event)
            {
                $('.view', tags_control).show();
                $('.edit', tags_control).hide();
                event.preventDefault();
            });

            $('.edit a.delete', context).bind('click', function (event)
            {
                tags_control.trigger('delete', { url: $(this).attr('href') });
                event.preventDefault();
            });

            $('select', context).bind('change', function(event)
            {
                if (this.selectedIndex == 0)
                {
                    return;
                }
                
                var tag = $(this).val();
                if (this.selectedIndex == $('option', this).size() - 1)
                {
                    tag = window.prompt("Enter new tag:");
                }
                if (tag)
                {
                    tags_control.trigger('add', { url: $(this).parent('form').attr('action'), tag: tag });
                }
                else
                {
                    this.selectedIndex = 0;
                }
            });

            tags_control.bind('delete', function(event, data)
            {
                tags_control.addClass('ajax_loading');
                $.ajax({
                    type: 'POST',
                    url: data.url,
                    data: { _method: 'DELETE'},
                    success: function(data, status)
                    {
                        replaceControl(data);
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
                    data: { _method: 'POST', id: data.tag },
                    success: function(data, status)
                    {
                        replaceControl(data);
                    }
                });
                return data;
            });

            function replaceControl(data)
            {
                tags_control.replaceWith(data);
                $('.tags_control', context).tags_control();
                $('.view a.show_edit', context).trigger('click');
            }
        });
    }
})(jQuery);