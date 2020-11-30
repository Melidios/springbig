var regExCheck = /^\s*([0-9a-zA-Z]+)\s*$/
var $errorSpan = $('#input-error');
var $inputField = $('#identifier');

$('#submit-btn').on('click', function() {
  if ( $inputField.val().length < 1) {
    $errorSpan.text('Minimum input length is at least 1');
    $errorSpan.removeClass('hidden');
    $inputField.addClass('error-input');
    return false
  } else if (!$inputField.val().match(regExCheck)) {
    $errorSpan.text('Please, input only letters and/or numbers.');
    $errorSpan.removeClass('hidden');
    $inputField.addClass('error-input');
    return false
  } else {
    $inputField.removeClass('error-input');
    $errorSpan.addClass('hidden');
  };
});
