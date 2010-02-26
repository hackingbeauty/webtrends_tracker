(function(){
  
  /*	=Namespace
  	...................................................................... */

  if(!window.PRIMEDIA) { 
    window.PRIMEDIA = {};
  }
  
  /*	=Utilities
  	...................................................................... */
  
  //Patch for IE - cannot use indexOf on Array for IE
  if(!Array.indexOf){
      Array.prototype.indexOf = function(obj){
          for(var i=0; i<this.length; i++){
              if(this[i]==obj){
                  return i;
              }
          }
          return -1;
      }
  }
  
  
  var h = function (stg) {                                        
    return stg.replace(/&/g,'&amp;').                                         
               replace(/>/g,'&gt;').                                           
               replace(/</g,'&lt;').                                           
               replace(/"/g,'&quot;');                                                                      
  };
  
  $.fn.zebra_stripe = function(){
    var prev = 'odd';
    $('tr', this).each(function(){
      $(this).removeClass('odd even');
      if( prev == 'odd'){
        $(this).addClass('even');
        prev = 'even';
      } else {
        $(this).addClass('odd');
        prev = 'odd';
      }
    });
  };
  
  $.fn.faint_input = function(){
    $(this).addClass('faint');
    $(this)
      .live('focus', function(){
        var self = $(this);
        if ( ! self.data('default') ) {
          self.data('default', self.val());
        }
        if ( self.data('default') == self.val() ){
          self.val('');            
          self.addClass('normal');
        }
    })
      .live('blur',function(){
        var self = $(this);
        if(self.val() == ''){
          self.val(self.data('default'));
          self.removeClass('normal');
          self.addClass('faint'); 
        }
    });
  };
  
  /*	=Search Object
  	...................................................................... */
  
  var Search = function(){
    this.init = function(){
      var input = $('#search-input');
      if( input.length ){
        input.focus(function(){
          $(this).val('');
        });
        
        $('#search-btn').click(function(){
          $(this).parents('form').submit();
        });
      }
    }
  }

  window.PRIMEDIA.Search = Search;
  
  /*	=KeyValueForm Object     
  	...................................................................... */
  
  var KeyValueForm = function(){ // constructor function object 
    this.init = function(){
      this.create_key_val();
       $('#kvp_form input:text').faint_input(); //utility function to make input value faint font
    },//end init
    this.create_key_val = function(){
      var kvp_form = document.getElementById("new_key_value_pair");
      if(kvp_form){
        kvp_form.onsubmit = function(){    
          $.ajax({
            type: 'post',
            url: '/key_value_pairs/', 
            data: $(kvp_form).serialize(),
            dataType: 'json',
            error: function(res) {
              var errors = JSON.parse(res.responseText);
              var error_list = $('<ul>');
              var error_container = $('#error_container');
              error_container.html('');
              for(var i=0, j=errors.length; i < j; i++)
                $('<li>' + errors[i] + '</li>').appendTo(error_list);
              error_list.appendTo(error_container);
              error_container.slideDown(400);
              setTimeout(function(){ error_container.slideUp(500); }, 8000);  
            },
            success: function(res){
              var kvp = res.key_value_pair;
              var new_row = $('<tr class="row"><td>' + kvp.key + '</td>' +
                    '<td>' + h(kvp.value) + '</td>' + 
                    '<td>' + kvp.key_val_type + '</td>' + 
                    '<td><a class="delete button" href="/key_value_pairs/' + kvp.id + '">Delete</a></td></tr>');             
             //zebra striping
             var prev = $('table#kvp-table tbody tr:last-child');
             if( prev.length ) {
               new_row.insertAfter(prev);
               var previous_class = prev.attr('class');             
               var next_class = previous_class.match(/even/) ? 'odd' : 'even';
               new_row.addClass(next_class);
             } else {
               new_row.appendTo($('#kvp-table tbody'));
               new_row.addClass('odd');
             }
             $('#kvp_form input:text').each(function(){//reset default inputs to faint values
               $(this).removeClass('normal');
               $(this).addClass('faint');
             });
             $('form#new_key_value_pair input#key_value_pair_value').val('value');//reset default input value
             $('form#new_key_value_pair input#key_value_pair_key') // auto-focus the value field
               .focus().val('')
               .removeClass('faint')
               .addClass('normal');
             //AJAX Delete button    
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
                     new_row.fadeOut(1000, function(){ $(this).remove(); });
                   }
                 });//end ajax
               }//end if
               return false;
             });//end click
            }//end success
          });//end ajax

          return false;
        }//end onsubmit
      }//endif keyval form
    }//end create_key_val
  }//end KeyValueForm
  window.PRIMEDIA.KeyValueForm = KeyValueForm;
  
  
  /*	=Tag Object (MultitrackTag and PageView Tag will inherit)
  	...................................................................... */
  
  var Tag = function(tag_type){ //constructor function object
    this.init = function(){
      this.create_tag_form_field();
      this.delete_tag_form_field();
      this.save_tag();
    },
    this.create_tag_form_field = function(){
      var create_btn = document.getElementById("create_" + tag_type +"_tag");
      if(create_btn){
        create_btn.onclick = function(){           
          if($('#'+ tag_type +'_add').is(':hidden')) {
            $('#'+ tag_type +'_add').show();
          }
          var form_row = $('#'+ tag_type +'_form_snippet').children(':first-child').clone().show();         
          $('#'+ tag_type +'_add').after(form_row); //add the form row after the div '<tag_type>_add'
          $('#'+ tag_type + ' input:text:visible').faint_input(); //utility function to make input value faint font
          return false;
        }
      } 
    },//end create_tag_form_field
    this.delete_tag_form_field = function(){
      $('#'+tag_type+' .clear').live('click', function(){
        var form_row = $(this).parents('form.create_' + tag_type + '_tag');
        $(form_row).fadeOut(300, function(){ $(this).remove(); });
      })
    },//end delete_tag_form_field
    this.save_tag = function(){     
      $('form.create_'+ tag_type +'_tag').live('submit',function(){
        var self = $(this);
        $.ajax({
          type: 'post',
          url: '/'+tag_type+'_tags/',
          data: self.serialize(),
          dataType: 'json',
          error: function(res) { 
           var errors = JSON.parse(res.responseText);
           var error_list = $('<ul>');
           var error_container = $('#error_container');
           error_container.html('');
           for(var i=0, j=errors.length; i < j; i++)
             $('<li>' + errors[i] + '</li>').appendTo(error_list);
             
           error_list.appendTo(error_container);
           error_container.slideDown(400);
           setTimeout(function(){ error_container.slideUp(500); }, 8000);
          },
          success: function(res){
            var tag, tag_type_name, tag_sort_key, tag_sort_key_name;
            if(tag_type == "page_view"){
              tag = res.page_view_tag;
              tag_type_name = "PageViewTag"; // mimic ruby class
              tag_sort_key = tag.location;
              tag_sort_key_name = "location";
            } else {
              tag = res.multitrack_tag;
              tag_type_name = "MultitrackTag";
              tag_sort_key = tag.hook;
              tag_sort_key_name = "hook";
            }
              
            var row_stg = '<tr>';
            
            if( tag_type == 'multitrack' ){ 
              row_stg += '<td><a href="/' + tag_type + '_tags/' + tag.id +'">' + tag.hook + '</a></td>';
              row_stg += '<td>' + tag.location + '</td>';
            } else {
              row_stg += '<td><a href="/' + tag_type + '_tags/' + tag.id +'">' + tag.location + '</a></td>';
            }
            
            row_stg += '<td>' + tag.description + '</td>' + 
            '<td>' + tag_type_name + '</td>' +
            '<td><a class="delete button" href="/' + tag_type + '_tags/'+ tag.id +'">Delete</a></td>' +
            '</tr>';
              
            var new_row = $(row_stg);
            
            var rows = $('table#'+tag_type+'_tags_table tbody tr');
            var hook_arr = [];
            
            rows.each(function(index){
              hook_arr.push($('td:first a', this).text()); // create an array of all locations
            }); 
            
            hook_arr.push(tag_sort_key);
            hook_arr.sort();
            var index = hook_arr.indexOf(tag_sort_key); // find where in the sorted array the newly added hook/location exists
            var prev_row = $(rows[index - 1]);
            
            if( rows.length && prev_row.length == 0 ){ // rows present, new_row should be first
              new_row.insertBefore($(rows[0]));
            } else if ( rows.length ) { // one or more rows present
              new_row.insertAfter(prev_row);
            } else { // no previous rows
              new_row.appendTo($('#'+tag_type+'_tags_table tbody'));
            }
            
            $('#'+tag_type+'_tags_table').zebra_stripe();
            
            $('a[href=/'+tag_type+'_tags/' + tag.id + ']:last').click(function(){
               var sure = confirm("Are you sure?");
               if ( ! sure ) {
                 return false;
               } else {
                 $.ajax({
                   type: 'post',
                   data: { '_method': 'delete', 'authenticity_token' : rails_authenticity_token },
                   url: this.href,
                   success: function(){
                     new_row.fadeOut(1000, function(){ 
                       new_row.remove(); 
                       $('#'+tag_type+'_tags_table').zebra_stripe(); 
                     });
                   }
                 });//end ajax
               }//end if
               return false;
             });//end click
            
            self.fadeOut(400, function(){
              $(this).remove(); // remove from inputs from dom
              $('.'+tag_type+'_tag_' + tag_sort_key_name + ':first').focus(); // focus the first pageview input
            });
          }//end success
        });//end ajax
        return false;
      })//end live
    }//end save_tag
  }
  window.PRIMEDIA.Tag = Tag;
  
})();

$(document).ready(function() {
  
  var kvp = new PRIMEDIA.KeyValueForm();
  kvp.init();
  
  var mt = new PRIMEDIA.Tag("multitrack");
  mt.init();
  
  var pt = new PRIMEDIA.Tag("page_view");
  pt.init();

  var s = new PRIMEDIA.Search();
  s.init();
  
});
