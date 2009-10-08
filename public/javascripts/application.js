(function(){

	//Create PRIMEDIA
	if(!window.PRIMEDIA) {window['PRIMEDIA'] = {}}	
	
  $.fn.inPlaceEdit = function(url){
    $(this).editInPlace({
      url: url,
      params: "_method=put&authenticity_token=" + encodeURIComponent(rails_authenticity_token), // to trick Rails into routing this url to the UPDATE
      error: function(json){
        var obj = eval( "(" + json.responseText + ")" );
        var errorMsg = obj['error'];
        $('#errors').html(errorMsg);
      },
      success: function(){
        $('#errors').html('');
      }
    });
  }
  
})();

$(document).ready (function() {
	
	$('.validate').inPlaceEdit(document.location.pathname + "/update_in_place");
	$('.validate_kvp').inPlaceEdit(document.location.pathname + "/update_kvp_in_place");
	
  $("#add_key_value").click(function() {
    $('ul#key_value_list').append($('#key_value_snippet').html());
  });

  $('#tag_hook').autocomplete('/tags/autocomplete', { extraParams: { element_id: "tag_hook" } }); 
  $('#tag_location').autocomplete('/tags/autocomplete', { extraParams: { element_id: "tag_location" } });
  
  $(".delete_tag_attr").live("click", function(){
    var answer = confirm('Are you sure?');
    if(!answer){ return false; }
    $(this).parent().remove();
    var id = $(this).siblings('.validate_kvp').attr('id').split("_")[1];
    
    $.ajax({
      type: "POST",
      url: "/key_value_pairs/" + id,
      data: {
        "_method": "DELETE",
        authenticity_token: rails_authenticity_token
      }
    });
  });
  
  $(".save_tag_attr").live("click", function(){
    var parent = $(this).parent();
    var key = $(this).siblings('.key_input').val();
    var val = $(this).siblings('.value_input').val();
    var tag_id = $(this).siblings('.tag_id_input').val();
    
    $.ajax({
      type: "POST",
      url: "/key_value_pairs",
      data: ({
        "key_value_pair[key]": key,
        "key_value_pair[value]": val,
        "key_value_pair[tag_id]": tag_id,
        authenticity_token: rails_authenticity_token
      }),
      success: function(msg){ 
        parent.remove();
        var path = document.location.pathname + "/update_kvp_in_place";
        
        var key_span = $("<span class='validate_kvp' id='key_"+ msg +"'>" + key + "</span>");
        var val_span = $("<span class='validate_kvp' id='value_"+ msg +"'>"+ val +"</span>");
        
        var li = $('<li></li>');
        li.append(key_span);
        li.append(val_span);
        li.append($('#delete_key_value_snippet').html());
        $('#key_value_list').append(li);

        key_span.inPlaceEdit(path);
        val_span.inPlaceEdit(path);
      },
      error: function(){
        alert('There was an error saving this key value pair.')
      }
    });
    
  });


});