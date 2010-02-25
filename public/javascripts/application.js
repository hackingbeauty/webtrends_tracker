(function(){
  
  /*	=Namespace
  	...................................................................... */

  if(!window.PRIMEDIA) { 
    window.PRIMEDIA = {};
  }
  
  /*	=Utilities
  	...................................................................... */
  
  var h = function (stg) {                                        
    return(                                                                 
      stg.replace(/&/g,'&amp;').                                         
          replace(/>/g,'&gt;').                                           
          replace(/</g,'&lt;').                                           
          replace(/"/g,'&quot;')                                         
    );                                                                      
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
  
  /*	=Search Object
  	...................................................................... */
  
  var Search = function(){};
  
  Search.prototype = {
    init: function(){
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
    this.faint_form_rows = function(){
      $('#kvp_form input:text').each(function(){
        $(this).addClass('faint');
      });
    },//end faint_form_rows
    this.form_row_events = function(){
      $('#kvp_form input:text')
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
    },//end form_row_events
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
  
  /*	=PageViewTag Object
  	...................................................................... */
  
  var PageViewTag = function() { //constructor function object
    this.form_row_events = function(){
      $('#pageviews input:text')
        .live('focus',function(){
          var self = $(this);
          if ( ! self.data('default') )
            self.data('default', self.val());
          
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
    },//end form_row_events
    this.create_tag_form_field = function(){
      var create_pageview_btn = document.getElementById("create-pageview-tag");
      if(create_pageview_btn){
        create_pageview_btn.onclick = function(){
          if($('#pageviews-add').is(':hidden')) {
            $('#pageviews-add').show();
          }
          var form_row = '<form class="create_page_view_tag" method="post" action="/page_view_tags">' +
            '<div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="'+ rails_authenticity_token +'" />' +
            '<div class="form-row">' +
            '<ul>' +
            '<li><input type="text" size="15" name="page_view_tag[location]" class="page_view_tag_location" value="location" autocomplete="off" /></li>' +
            '<li><input type="text" size="15" name="page_view_tag[description]" class="page_view_tag_description" value="description" autocomplete="off" /></li>' +
            '<li><input class="hidden" class="page_view_tag_product_id" name="page_view_tag[product_id]" type="hidden" value="'+ PRIMEDIA_product_id +'" /></li>' +
            '<li><a class="clear button">Clear</a></li>' +
            '<li><input type="submit" class="button submit-pageview-btn" value="Save" /></li>' +
            '</ul>' +
            '</div>' +
            '</form>';          
          $('#pageviews-add').after(form_row);
          $('#pageviews input:text').each(function(){
            $(this).addClass('faint');
          });    
          return false;
        }
      }
    },//end create_tag
    this.delete_pageview_tag_form_row = function(){
      $('.clear').live('click', function(){
        var form_row = $(this).parents('form.create_page_view_tag');
        $(form_row).fadeOut(300, function(){ $(this).remove(); });
      })
    },//end delete_pageview_tag_form_row
    this.save_page_view_tag = function(){
      $('form.create_page_view_tag').live('submit',function(){
        var self = $(this);
        $.ajax({
          type: 'post',
          url: '/page_view_tags/',
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
            var page_view_tag = res.page_view_tag;

            var new_row = $('<tr><td><a href="/page_view_tags/' + page_view_tag.id +'">' + page_view_tag.location + '</a></td>' +
                  '<td>' + page_view_tag.description + '</td>' + 
                  '<td>PageViewTag</td>' +
                  '<td><a class="delete button" href="/page_view_tags/'+page_view_tag.id +'">Delete</a></td></tr>d');
            
            var rows = $('table#page-view-tags-table tbody tr');
            var hook_arr = [];
            
            rows.each(function(index){
              hook_arr.push($('td:first a', this).text()); // create an array of all locations
            }); 
            
            hook_arr.push(page_view_tag.location);
            hook_arr.sort();
            var index = hook_arr.indexOf(page_view_tag.location); // find where in the sorted array the newly added hook exists
            var prev_row = $(rows[index - 1]);
            
            if( rows.length && prev_row.length == 0 ){
              new_row.insertBefore($(rows[0]));
            } else if ( rows.length ) {
              new_row.insertAfter(prev_row);
            } else {
              new_row.appendTo($('#page-view-tags-table tbody'));
            }
            
            $('#page-view-tags-table').zebra_stripe();
            
            $('a[href=/page_view_tags/' + page_view_tag.id + ']').click(function(){
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
            
            self.fadeOut(400, function(){
              $(this).remove(); // remove from inputs from dom
              $('.page_view_tag_location:first').focus(); // focus the first pageview input
            });
          }//end success
        });//end ajax
        return false;
      })//end live
    }// end save_page_view_tag
  }
  window.PRIMEDIA.PageViewTag = PageViewTag;
  
  
  /*	=MultitrackTag Object
  	...................................................................... */
  	
  var MultitrackTag = function(){ // constructor function object
    this.form_row_events = function(){
      $('#multitracks input:text')
        .live('focus',function(){
          var self = $(this);
          if ( ! self.data('default') )
            self.data('default', self.val());

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
    },//end form_row_events
    this.create_tag_form_field = function(){
      var create_multitrack_btn = document.getElementById("create-multitrack-tag");
      if(create_multitrack_btn){        
        create_multitrack_btn.onclick = function(){
          if($('#multitracks-add').is(':hidden')) {
            $('#multitracks-add').show();
          }
          $('#multitracks-add').after('<form class="create_multitrack_tag" method="post" action="/multitrack_tags">' +
            '<div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="'+ rails_authenticity_token +'" />' +
            '<div class="form-row">' +
            '<ul>' +
            '<li><input type="text" size="10" name="multitrack_tag[hook]" class="multitrack_tag_hook" value="hook" autocomplete="off" /></li>' +
            '<li><input type="text" size="15" name="multitrack_tag[location]" class="multitrack_tag_location" value="location" autocomplete="off" /></li>' +
            '<li><input type="text" size="15" name="multitrack_tag[description]" class="multitrack_tag_description" value="description" autocomplete="off"/></li>' +
            '<li><input class="hidden" class="multitrack_tag_product_id" name="multitrack_tag[product_id]" type="hidden" value="'+ PRIMEDIA_product_id +'" /></li>' +
            '<li><a class="clear button">Clear</a></li>' +
            '<li><input type="submit" class="button submit-multitrack-btn" value="Save" /></li>' +
            '</ul>' +
            '</div>' +
            '</form>');
            $('form.create_multitrack_tag input:text').each(function(){//make input value of inputs faint
              $(this).addClass("faint");
            });
          return false;
        }
      }
    },//end create_tag
    this.delete_multitrack_tag_form_row = function(){
      $('.clear').live('click', function(){
        var form_row = $(this).parents('form.create_multitrack_tag');
        $(form_row).fadeOut(300, function(){ $(this).remove(); });
      })
    },//end delete_multitrack_tag_form_row
    
    this.save_multitrack_tag = function(){
      $('form.create_multitrack_tag').live('submit',function(){
        var self = $(this);
        $.ajax({
          type: 'post',
          url: '/multitrack_tags/',
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
            var multitrack_tag = res.multitrack_tag;
                          
            var new_row = $('<tr><td><a href="/multitrack_tags/' + multitrack_tag.id + '">' + multitrack_tag.hook + '</a></td>' +
                  '<td>' + multitrack_tag.location + '</td>' + 
                  '<td>' + multitrack_tag.description + '</td>' + 
                  '<td>MultitrackTag</td>' +
                  '<td><a class="delete button" href="/multitrack_tags/'+ multitrack_tag.id +'">Delete</a></td></tr>d')      
            
            var rows = $('table#multitrack-tags-table tbody tr');
            var hook_arr = [];
            
            rows.each(function(index){
              hook_arr.push($('td:first a', this).text()); // create an array of all multitrack hooks
            }); 
            
            hook_arr.push(multitrack_tag.hook);
            hook_arr.sort();
            var index = hook_arr.indexOf(multitrack_tag.hook); // find where in the sorted array the newly added hook exists
            var prev_row = $(rows[index - 1]);
                        
            if( rows.length && prev_row.length == 0 ){
              new_row.insertBefore($(rows[0]));
            } else if ( rows.length ) {
              new_row.insertAfter(prev_row);
            } else {
              new_row.appendTo($('#multitrack-tags-table tbody'));
            }
            
            $('#multitrack-tags-table').zebra_stripe();            
            
            //AJAX delete
            $('a[href=/multitrack_tags/' + multitrack_tag.id + ']').click(function(){
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
            
            self.fadeOut(400, function(){
              $(this).remove(); // remove from inputs from dom
              $('.multitrack_tag_hook:first').focus(); // focus the first multitrack input
            });
          }//end success
        });//end ajax
        return false;
      })//end live
    }//end save_multitrack_tag
    
  }//end MultitrackTag object
  window.PRIMEDIA.MultitrackTag = MultitrackTag;

})();

$(document).ready(function() {
  
  var kvp = new PRIMEDIA.KeyValueForm();
  kvp.create_key_val();
  kvp.faint_form_rows();
  kvp.form_row_events();
  
  var pt = new PRIMEDIA.PageViewTag();
  pt.create_tag_form_field();
  pt.delete_pageview_tag_form_row();
  pt.save_page_view_tag();
  pt.form_row_events();
  
  var mt = new PRIMEDIA.MultitrackTag();
  mt.create_tag_form_field();
  mt.delete_multitrack_tag_form_row();
  mt.save_multitrack_tag();
  mt.form_row_events();
  
  var s = new PRIMEDIA.Search();
  s.init();
  
});
