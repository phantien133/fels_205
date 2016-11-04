$(document).ready(function() {
  $('#search_user_box').keyup(function () {
    key = $(this).val();
    searchUser('/users?key=' + key);
  });
  $('#search_follows_box').keyup(function () {
    key = $(this).val();
    strUrl = window.location.href.split("?");
    url = strUrl[0] + '?key=' +key;
    console.log(url);
    searchUser(url);
  });
});
function searchUser(url) {
  $.ajax({
    type: 'GET',
    url: url,
    dataType: 'script',
    success: function(data){
      $("#connect_failed").hide();
    },
    error: function(error_message) {
      $("#connect_failed").show();
    },
  });
}
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
