// Use this file to require common dependencies or to setup useful test functions.

jQuery.fn.fixture = function() {
  this.each(function() {
    if (this.original) {
      $(this).html(this.original);
    } else {
      this.original = $(this).html();
    }
  });
};

function isHeadless() {
    return navigator.userAgent.match(/Envjs/);
}