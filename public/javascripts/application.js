(function(){
	
  /*	=Namespace
  	...................................................................... */

  if(!window.PRIMEDIA) { 
    window.PRIMEDIA = {};
  }

  
  /*	=KeyValueForm Object
  	...................................................................... */
  
  var KeyValueForm = function(){ // constructor function object
    
    this.create_key_val = function(){
      var kvp_form = document.getElementById("new_key_value_pair");
      if(kvp_form)
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
           //AJAX Delete    
           $('a[href=/key_value_pairs/' + kvp.id + ']').click(function(){
             var sure = confirm("Are you sure?");
             if ( ! sure ) {
               return false;
             } else {
               $.ajax({
                 type: 'post',
                 data: { '_method': 'delete', 'authenticity_token' : rails_authenticity_token },
                 url: this.href,
                 success: function(){
                   $('#key_val_table table tr:last').fadeOut(1000);
                 }
               });
               
             }
             return false;
           });
          }//end success
        });
        return false;
      }//end onsubmit
    }//end create_key_val
  }//end KeyValueForm
  window.PRIMEDIA.KeyValueForm = KeyValueForm;

  var MultitrackTag = function(){ // constructor function object
    this.create_tag_form_field = function(){
      var create_multitrack_btn = document.getElementById("create-multitrack-tag");
      if(create_multitrack_btn){        
        create_multitrack_btn.onclick = function(){
          if($('#multitracks-add').is(':hidden')) {
            $('#multitracks-add').show();
          }
          $('#multitracks-add').after('<form class="create_tag" method="post" action="/multitrack_tags">' +
            '<div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="'+ rails_authenticity_token +'" />' +
            '<div class="form-row">' +
            '<input type="text" size="10" name="multitrack_tag[hook]" class="multitrack_tag_hook" />' +
            '<input type="text" size="15" name="multitrack_tag[location]" class="multitrack_tag_location" />' +
            '<input type="text" size="15" name="multitrack_tag[description]" class="multitrack_tag_description" />' +
            '<input class="hidden" class="multitrack_tag_product_id" name="multitrack_tag[product_id]" type="hidden" value="'+ PRIMEDIA_product_id +'" />' +
            '<a class="clear button">Clear</a>' +
            '<a class="submit-multitrack-btn button">Save</a>' +
            '</div>' +
            '</form>');
          return false;
        }
      }
    },//end create_tag
    
    this.delete_multitrack_tag_form_row = function(){
      $('.clear').live('click', function(){
        var form_row = $(this).parents('form.create_tag');
        $(form_row).fadeOut(300);
      })
    },//end clear_multitrack_tag_form_row
    
    this.save_multitrack_tag = function(){
      $('.submit-multitrack-btn').live('click',function(){
        $('form.create_tag').each(function(index){
          var hook_val = $(this).find('input.multitrack_tag_hook').val();
          if(hook_val != ""){//create the post if a hook is supplied
            $.ajax({
              type: 'post',
              url: '/multitrack_tags/',
              data: $(this).serialize(),
              dataType: 'json',
              error: function(res) { 
               alert("Multitrack tag could not be created");
              },
              success: function(res){
                var multitrack_tag = res.multitrack_tag;
                $('<tr><td>' + multitrack_tag.hook + '</td>' +
                      '<td>' + multitrack_tag.location + '</td>' + 
                      '<td>' + multitrack_tag.description + '</td>' + 
                      '<td>' + multitrack_tag.kind + '</td>' +
                      '<td><a class="button" href="/multitrack_tags/'+ multitrack_tag.id +'">Delete</a></td></tr>d').
                  appendTo($('table#multitrack-tags-table'));
                $('form.create_tag').find(':input:text').each(function(){
                  $(this).val(''); //clear the inputs
                });
              }
            });
          }
        })//end each
      })//end live
    }//end save_multitrack_tag
    
  }//end MultitrackTag object
  window.PRIMEDIA.MultitrackTag = MultitrackTag;

})();

$(document).ready(function() {
  
  var kvp = new PRIMEDIA.KeyValueForm();
  kvp.create_key_val();
  
  var mt = new PRIMEDIA.MultitrackTag();
  mt.create_tag_form_field();
  mt.delete_multitrack_tag_form_row();
  mt.save_multitrack_tag();
  
});












//   
// $.fn._delete = function(success){
//   this.click(function(){
//      var sure = confirm("Are you sure?");
//      if ( ! sure )
//        return false;
//        
//     $.ajax({
//       type: 'post',
//       data: { '_method': 'delete', 'authenticity_token' : rails_authenticity_token },
//       url: this.href,
//       success: success
//     });
//     
//     return false;
//    });
// };