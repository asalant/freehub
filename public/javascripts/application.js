function instrumentSigninForm(form, submit_button) {
  $(submit_button).focus();
  $(submit_button).enable();

  var submitted = false;
  Event.observe(form, 'submit', function() {
      if (submitted) {
          $(submit_button).disable();
      }
      submitted = true;
  });
}