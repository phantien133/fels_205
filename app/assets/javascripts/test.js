function submitTestForm(submit_value) {
  form = $('#result-form');
  form.find('#auto_commit').val(submit_value);
  form.submit();
}
function countdownTimer(time) {
  var timer = time * 60, minutes, seconds;
  timeAutoSave = timer - timer / 10
  testTimer = setInterval(function () {
    minutes = parseInt(timer / 60, 10);
    seconds = parseInt(timer % 60, 10);
    minutes = minutes < 10 ? '0' + minutes : minutes;
    seconds = seconds < 10 ? '0' + seconds : seconds;
    $('#countdown-timer').html(minutes + ':' + seconds);
    if (timer < timeAutoSave) {
      submitTestForm('save');
      timeAutoSave -= time * 6
    }
    if (--timer < 0) {
      clearInterval(testTimer);
      submitTestForm('finish');
    }
  }, 1000);
}
$(document).ready(function() {
  number_of_selected = $('input[type="radio"]:checked').length
    $('#test-progress').html(number_of_selected);
  $('input[type="radio"]').change(function () {
    number_of_selected = $('input[type="radio"]:checked').length
    $('#test-progress').html(number_of_selected);
  });
});

