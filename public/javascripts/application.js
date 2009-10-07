(function(){

	//Create PRIMEDIA
	if(!window.PRIMEDIA) {window['PRIMEDIA'] = {}}	

	//Helper function to check if an element (i.e. div) exists. Argument is element id
	var exists = function(element) {
		if (!document.getElementById(element)) {
			return false;
		} else {
			return true;
		}
	}
	window['PRIMEDIA']['exists'] = exists;
	
})();

$(document).ready (function() {
	
	$(".validate").editInPlace({
      url: document.location.pathname + "/update_in_place",
      params: "_method=put&authenticity_token=" + rails_authenticity_token, //to trick Rails into routing this url to the UPDATE
      error: function(json){
        var obj = eval( "(" + json.responseText + ")" );
        var errorMsg = obj['error'];
        $('#errors').html(errorMsg);
      },
      success: function(){
        $('#errors').html('');
      }
  });
	
});