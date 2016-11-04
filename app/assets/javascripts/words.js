function add_new_answer(answer,correct){
  index_of_answer = 0;
  while ($('#answer_' + index_of_answer).length != 0) {
    index_of_answer++;
  }
  if (index_of_answer == 0) {
    $('#answer-fields').html('<div id="answer_0" class="row form-group"></div>');
  }
  else{
    pre_index_of_answer = index_of_answer - 1;
    $('<div id="answer_' + index_of_answer + '" class="row form-group"></div>').insertAfter('#answer_'
      + pre_index_of_answer);
  }
  html=' <label class="pull-left btn glyphicon glyphicon-remove"'
    + ' onclick="delete_answers('
    + index_of_answer + ')"></label>'
    + '<div class="form-inline form-group" id="answer_0_conttent">'
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
    + 'name="word[answers_attributes][' + index_of_answer + '][correct]" class="option_checkbox">'

    + '</div>';
  $('#answer_' + index_of_answer).html(html);
}

function delete_answers(index){
  $('#answer_' + index).remove();
}

function destroy_old_answer(id,index) {
  html = '<input name="word[answers_attributes][' + index + '][_destroy]"'
    + 'type="hidden" value="' + id + '">';
  $('#answer_' + index).append(html);
  $('#answer_' + index).hide();
}

function delete_word(id, name) {
  if (confirm(id + ' : ' + name) == true) {
    $.ajax({
      type: 'DELETE',
      url: '/words/' + id,
      success: function(data){
        alert(data.status);
        $('#tr_word_id_' + id).remove();
        $('#answers_word_id_' + id).remove();
      },
      error: function(error_message) {
        connect_failed.show();
      },
    });
  }
}

function submit_words_search_form(){
  str = $('#words_search_form').serialize();
  $.ajax({
    type: "GET",
    url: '/words?' + str,
    dataType: "script",
    success: function(data){
    },
    error: function(error_message) {
      connect_failed.show();
    },
  });
}

$(document).ready(function() {
  $('#search_words').keyup(function () {
    submit_words_search_form()
  });
  $('form').on('change', 'input[type=checkbox]', function() {
    $('.option_checkbox').not(this).prop('checked', false);
  });
});
