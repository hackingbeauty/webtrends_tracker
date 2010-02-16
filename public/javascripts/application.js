(function(){
	
  /*	=Namespace
  	...................................................................... */

  if(!window.PRIMEDIA) { 
    window.PRIMEDIA = {};
  }

  
  /*	=KeyValueForm Object
  	...................................................................... */
    
  var KeyValueForm = function(){ //constructor function object
    this.create_key_val = function(){
      var kvp_form = document.getElementById("new_key_value_pair");
      kvp_form.onsubmit = function(){
        $.ajax({
          type: 'post',
          url: '/key_value_pairs/', 
          data: $(kvp_form).serialize(),
          dataType: 'json',
          error: function() { alert('Key value pair could not be created'); },
          success: function(res){
            var kvp = res.key_value_pair;
            $('<tr><td>' + kvp.key + '</td>' +
                  '<td>' + kvp.value + '</td>' + 
                  '<td>' + kvp.key_val_type + '</td>' + 
                  '<td><a class="button" href="/key_value_pairs/' + kvp.id + '">Delete</a></td></tr>').
              appendTo($('#key_val_table table'));
              
           $('a[href=/key_value_pairs/' + kvp.id + ']').click(function(){
             var sure = confirm("Are you sure?");
             if ( ! sure )
               return false;
               
            $.ajax({
              type: 'post',
              data: { '_method': 'delete', 'authenticity_token' : rails_authenticity_token },
              url: this.href,
              success: function(){
                $('#key_val_table table tr:last').fadeOut(1000);
              }
            });
            
            return false;
           });
          }
        });
        return false;
      }
    }
  }
  window.PRIMEDIA.KeyValueForm = KeyValueForm;

})();

$(document).ready(function() {
  
  var kvp = new PRIMEDIA.KeyValueForm();
  kvp.create_key_val();
  
});