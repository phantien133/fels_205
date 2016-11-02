
$(document).ready(function() {
  $('#search_categories').keyup(function () {
    key = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/categories?key=' + key,
      dateType: 'script',
      success: function(data){
        categories = data['categories']
        $('#connect_failed').hide();
        html='';
        for(i = 0; i < categories.length; i++){
          html += '<tr id="tr_category_id_' + categories[i].id + '">'
          + '<td>' + categories[i].id + '</td>'
          + '<td><p id="tr_name_categori_id_' + categories[i].id
          + '"><a src="categories/' + categories[i].id + '">'
          + categories[i].name + '</a></p></td>';
          if (categories[i].lessons != null ) {
            html += '<td>' + categories[i].lessons.length + '</td>';
          }
          else{
            html += '<td> ' + 0 + '</td>'
          }
          html += '<td> ' + categories[i].created_at + '</td>'
          + '<td>'
          + '<a class="btn btn-default" href="/categories/'
          + categories[i].id
          + '"><i class="glyphicon glyphicon-eye-open"></i></a> ';
          if (data['admin']==1) {
            html += '<button class= "btn btn-warning"'
            + 'onclick="edit_category(' + categories[i].id + ',\''
            + categories[i].name + '\')">'
            + '<i class="glyphicon glyphicon-edit"></i></button> '
            + '<button class= "btn btn-danger"'
            + 'onclick="delete_category(' + categories[i].id + ',\''
            + categories[i].name + '\')">'
            + '<i class="glyphicon glyphicon-remove-circle"></i>'
            + '</button> ';
          }
          html += '</td></tr>';
        }
        $('#result_search').html(html);
        make_paginate(data['current'],data['total_entries'],
          data['per_page'],key);
      },
      error: function(error_message) {
        connect_failed.show();
      },
    });
  });
});
function make_paginate(current,total_entries,per_page,key){
  if (total_entries <= per_page) {
    $('#will_paginate').html('');
  }
  else{
    html = '<ul class="pagination">';
    length = total_entries / per_page;
    total_entries % per_page > 0 ? length++ : length;
    if (current == 1) {
      html += '<li class="prev previous_page disabled">'
      + '<a href="#">← </a></li>';
    }
    else{
      pre = current - 1;
      html += '<li class="prev previous_page "><a rel="prev start" href="'
      + window.location.href + '?key=' + key + '&commit=Search&page=' + pre
      + '">← </a></li>';
    }

    for (var i = 1; i <= length; i++) {
      if (i == current) {
        html += '<li class="active">';
      }
      else{
        html += '<li>';
      }
      html += '<a rel="start" href="'
        + window.location.href + '?key=' + key + '&commit=Search&page=' + i
        + '">'
        + i + '</a></li>';
    }

    if (current == length) {
      html += '<li class="next next_page disabled"><a href="#"> →</a>'
      + '</li>';
    }
    else{
      next = current + 1;
      html += '<li class="next next_page "><a rel="prev start" href="'
      + window.location.href + '?key=' + key + '&commit=Search&page='
      + next + '"> →</a></li>';
    }
    html += '</ul>'
    $('#will_paginate').html(html);
  }

}
function delete_category(id, name) {
  if (confirm(id + ' : ' + name) == true) {
    $.ajax({
      type: 'DELETE',
      url: '/categories/' + id,
      success: function(data){
        alert(data.status);
        $('#tr_category_id_' + id).remove();
      },
      error: function(error_message) {
        connect_failed.show();
      },
    });
  }
}
function edit_category(id){
  $.ajax({
    type: 'GET',
    url:'/categories/' + id + '/edit',
    dataType: 'script'
  });
}
function cancel_edit_category(id,name){
  html='<a src="categories/' + id + '">'
  + name + '</a>';
  $('#tr_name_categori_id_'+id).html(html);
}
