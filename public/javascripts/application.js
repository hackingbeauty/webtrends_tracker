(function(){
	if(!window.PRIMEDIA) {window['PRIMEDIA'] = {}} //Create PRIMEDIA
	
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
	// when you click an in-place-editable span, this is the input that appears
	// <input class="inplace_field" type="text" value="desc" name="inplace_value"/>

	// hack! fill in the edit in place field before the edit in place code makes it disappear
	$('.ac_even, .ac_odd').live('mouseover', function(){ $('.inplace_field').val($(this).text());})
	
	$('.validate').live('click', function(){
	  var id = $(this).attr('id');
	  $('.inplace_field').autocomplete('/tags/autocomplete', { extraParams: { element_id: id } });
	});
	
	$('.validate_kvp').live('click', function(){
	  var id = $(this).attr('id');
	  if (id.match("key")){ id = "key"; } else { id = "value"; }
	  $('.inplace_field').autocomplete('/key_value_pairs/autocomplete', { extraParams: { element_id: id } });
	});
	
	$('.validate').inPlaceEdit(document.location.pathname + "/update_in_place");
	$('.validate_kvp').inPlaceEdit(document.location.pathname + "/update_kvp_in_place");
	  
  $("#add_key_value").click(function() {
    $('ul#key_value_list').append($('#key_value_snippet').html());
    $('ul#key_value_list .key_input').autocomplete('/key_value_pairs/autocomplete', { extraParams: { element_id: "key" } });
    $('ul#key_value_list .value_input').autocomplete('/key_value_pairs/autocomplete', { extraParams: { element_id: "value" } });
  });

  $('#tag_hook').autocomplete('/tags/autocomplete', { extraParams: { element_id: "tag_hook" } });
  $('#tag_location').autocomplete('/tags/autocomplete', { extraParams: { element_id: "tag_location" } });
  
  $(".delete_tag_attr").live("click", function(){
    var sure = confirm('Are you sure?');
    if(!sure){ return false; }
    
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