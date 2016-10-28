$(document).ready(function() {
  $('#search_user_box').keyup(function () {
    key = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/users?key=' + key,
      dataType: 'script',
      success: function(data){
        $("#connect_failed").hide();
      },
      error: function(error_message) {
        $("#connect_failed").show();
      },
    });
  });
});
function deleteUser(id,strConfirm){
  if (confirm(strConfirm)) {
    $.ajax({
      type: 'DELETE',
      url: '/users/' + id,
      success: function(data){
        $("#user_content_id_" + id).remove();
      },
      error: function(error_message) {
        $("#connect_failed").show();
      },
    });
  }
}
