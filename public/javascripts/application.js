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
	
	
});