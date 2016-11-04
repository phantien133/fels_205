index_of_answer = 0;
function add_new_answer(answer,correct){
  next_index_of_anser = index_of_answer + 1;
  html=' <label class="pull-left btn glyphicon glyphicon-remove"'
    + ' onclick="delete_answers('
    + index_of_answer + ')"></label>'
    + '<div class="form-inline form-group" id="answer_0_conttent">'
    + '<label for="word_answers_attributes_'+ index_of_answer + '_content">'
    + answer
    + '</label>'
    + '<textarea id="word_answers_attributes_' + index_of_answer
    + '_content" name="word[answers_attributes][' + index_of_answer + '][content]"'
    + 'class="form-control"></textarea>'
    + ' <label for="word_answers_attributes_' + index_of_answer
    + '_correct">'
    + correct +'</label>\n'
    + '<input type="hidden" value="false" name="word[answers_attributes]['
    + index_of_answer + '][correct]">'
    + '<input type="checkbox" id="word_answers_attributes_'
    + index_of_answer + '_correct" value="true"'
    + 'name="word[answers_attributes][' + index_of_answer + '][correct]">'

    + '</div>';

  $('<div id="answer_' + next_index_of_anser + '"></div').insertAfter('#answer_'
    + index_of_answer);
  $('#answer_' + index_of_answer).html(html);
  index_of_answer++;
}
function delete_answers(index){
  $('#answer_' + index).remove();
}
function search_words_by_category_id(sel){
  if (sel.value) {
    $.ajax({
      type: "GET",
      url:"/words?category_id=" + sel.value,
      dataType: "script",
      success: function(data){
        $('search_words').value='';
      },
      error: function(error_message) {
        connect_failed.show();
      },
    });
  }
}
$(document).ready(function() {
  $('#search_words').keyup(function () {
    category_id = $("#select_category_id").val();
    str = '/words?key=' +  $(this).val();
    if (category_id != '') {
      str += '&category_id=' + category_id;
    }
    $.ajax({
      type: "GET",
      url: str,
      dataType: "script",
      success: function(data){
      },
      error: function(error_message) {
        connect_failed.show();
      },
    });
    console.log(str);
  });
});

