// Always set the csrf token for ajax requests
(function($)
{
    $.ajaxSetup({
        beforeSend: function(xhr) {
            var token = $('meta[name="csrf-token"]').attr('content');
            xhr.setRequestHeader('X-CSRF-TOKEN', token);
            console.log('X-CSRF-TOKEN', token);
        }
    });
})(jQuery);