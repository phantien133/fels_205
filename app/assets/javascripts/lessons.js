$(document).ready(function() {
  $('#search_lessons').keyup(function () {
    submit_lessons_search_form();
  });
});

function submit_lessons_search_form(){
  str = $('#search_lessons_form').serialize();
  $.ajax({
    type: "GET",
    url: '/lessons?' + str,
    dataType: "script",
    success: function(data){
    },
    error: function(error_message) {
      connect_failed.show();
    },
  });
}

function delete_lesson(id, name) {
  $.ajax({
    type: 'DELETE',
    url: '/lessons/' + id,
    dataType: 'script'
  });
}
