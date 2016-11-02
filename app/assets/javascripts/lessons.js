$(document).ready(function() {
  $('#search_lessons').keyup(function () {
    key = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/lessons?' + $('#search_category_form').serialize(),
      dataType: 'script',
      success: function(data){
        $('#connect_failed').hide();
      },
      error: function(error_message) {
        $('#connect_failed').show();
      },
    });
  });
});
function search_lessons_by_category_id(sel) {
  if (sel.value) {
    $.ajax({
      type: 'GET',
      url:'/lessons?category_id=' + sel.value,
      dataType: 'script',
      success: function(data){
        $('search_lessons').value='';
      },
      error: function(error_message) {
        connect_failed.show();
      },
    });
  }
}
function delete_lesson(id, name) {
  if (confirm(id + ' : ' + name) == true) {
    $.ajax({
      type: 'DELETE',
      url: '/lessons/' + id,
      success: function(data){
        alert(data.status);
        $('#tr_lesson_id_' + id).remove();
      },
      error: function(error_message) {
        connect_failed.show();
      },
    });
  }
}
