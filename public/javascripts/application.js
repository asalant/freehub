function instrumentSigninForm(form, submit_button) {
  $(submit_button).focus();
  $(form).enable();

  var submitted = false;
  Event.observe(form, 'submit', function() {
      if (submitted) {
          $(form).disable();
      }
      submitted = true;
  });
}