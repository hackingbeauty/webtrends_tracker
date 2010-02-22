(function(){
	
	
  /*	=Namespace
  	...................................................................... */

  if(!window.PRIMEDIA) { 
    window.PRIMEDIA = {};
  }

  
  /*	=KeyValueForm Object     
  	...................................................................... */
  
  var KeyValueForm = function(){ // constructor function object 
    this.feint_input_value = function(){
      $('form#new_key_value_pair input:text').each(function(){
        $(this).addClass("feint");
        $(this).focus(function(){
          $(this).val('');
          $(this).addClass('normal');
        });
      });//end each
    },//end feint_input_value
    this.create_key_val = function(){
      var kvp_form = document.getElementById("new_key_value_pair");
      if(kvp_form)
      kvp_form.onsubmit = function(){
        var key_input = $(this).find('input#key_value_pair_key').val();
        if(key_input != ""){//create the post if a hook is supplied
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
                    '<td><a class="delete button" href="/key_value_pairs/' + kvp.id + '">Delete</a></td></tr>').
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
                 });//end ajax
               
               }//end if
               return false;
             });//end click
             $('form#new_key_value_pair').find(':input:text').each(function(){
               $(this).val(''); //clear the inputs
               $(this).removeClass('normal');
               $(this).addClass('feint');
             });
             $('form#new_key_value_pair input#key_value_pair_key').val('key');
             $('form#new_key_value_pair input#key_value_pair_value').val('value');
            }//end success
          });//end ajax
        }//end if
        return false;
      }//end onsubmit
    }//end create_key_val
  }//end KeyValueForm
  window.PRIMEDIA.KeyValueForm = KeyValueForm;
  
  
  /*	=PageViewTag Object
  	...................................................................... */
  
  var PageViewTag = function() { //constructor function object
    this.form_row_events = function(){
      $('#pageviews input:text').live('focus',function(){
        var self = $(this);
        self.data('default', self.val());
        self.val('');
        self.addClass('normal');
      });
      $('#pageviews input:text').live('blur',function(){
        var self = $(this);
        if(self.val() == ''){
          self.val(self.data('default'));
          self.removeClass('normal');
          self.addClass('feint');
        }
      });
    },
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
            '<li><input type="text" size="15" name="page_view_tag[location]" class="page_view_tag_location" value="location" /></li>' +
            '<li><input type="text" size="15" name="page_view_tag[description]" class="page_view_tag_description" value="description" /></li>' +
            '<li><input class="hidden" class="multitrack_tag_product_id" name="page_view_tag[product_id]" type="hidden" value="'+ PRIMEDIA_product_id +'" /></li>' +
            '<li><a class="clear button">Clear</a></li>' +
            '<li><input type="submit" class="button submit-pageview-btn" value="Save" /></li>' +
            '</ul>' +
            '</div>' +
            '</form>';          
          $('#pageviews-add').after(form_row);
          $('#pageviews input:text').each(function(){
            $(this).addClass('feint');
          });    
          return false;
        }
      }
    },//end create_tag
    this.delete_pageview_tag_form_row = function(){
      $('.clear').live('click', function(){
        var form_row = $(this).parents('form.create_page_view_tag');
        $(form_row).fadeOut(300);
      })
    },//end delete_pageview_tag_form_row
    this.save_page_view_tag = function(){
      $('form.create_page_view_tag').live('submit',function(){
        $.ajax({
          type: 'post',
          url: '/page_view_tags/',
          data: $(this).serialize(),
          dataType: 'json',
          error: function(res) { 
           var errors = JSON.parse(res.responseText);
           var error_list = $('<ul>');
           var error_container = $('#error_container');
           error_container.html('');
           for(var i=0, j=errors.length; i < j; i++){
             $('<li>' + errors[i] + '</li>').appendTo(error_list);
           }
           error_list.appendTo(error_container);
           error_container.slideDown(400);
           setTimeout(function(){
             error_container.slideUp(500);
           }, 8000);
          },
          success: function(res){
            var page_view_tag = res.page_view_tag;
            var previous_class = $('table#page-view-tags-table tbody tr:last-child').attr('class');
            var next_class = previous_class.match(/even/) ? 'odd' : 'even';

            var new_row = $('<tr><td><a href="/page_view_tags/' + page_view_tag.id +'">' + page_view_tag.location + '</a></td>' +
                  '<td>' + page_view_tag.description + '</td>' + 
                  '<td>PageViewTag</td>' +
                  '<td><a class="delete button" href="/page_view_tags/'+page_view_tag.id +'">Delete</a></td></tr>d');
            new_row.insertAfter($('table#page-view-tags-table tbody tr:last-child'));
            new_row.addClass(next_class);
            $('form.create_page_view_tag').find(':input:text').each(function(){
              $(this).val(''); //clear the inputs
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
      $('#multitracks input:text').live('focus',function(){
        var self = $(this);
        self.data('default', self.val());
        self.val('');
        self.addClass('normal');
      });
      $('#multitracks input:text').live('blur',function(){
        var self = $(this);
        if(self.val() == ''){
          self.val(self.data('default'));
          self.removeClass('normal');
          self.addClass('feint');
        }
      });
    },
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
            '<li><input type="text" size="10" name="multitrack_tag[hook]" class="multitrack_tag_hook" value="hook"/></li>' +
            '<li><input type="text" size="15" name="multitrack_tag[location]" class="multitrack_tag_location" value="location" /></li>' +
            '<li><input type="text" size="15" name="multitrack_tag[description]" class="multitrack_tag_description" value="description" /></li>' +
            '<li><input class="hidden" class="multitrack_tag_product_id" name="multitrack_tag[product_id]" type="hidden" value="'+ PRIMEDIA_product_id +'" /></li>' +
            '<li><a class="clear button">Clear</a></li>' +
            '<li><input type="submit" class="button submit-multitrack-btn" value="Save" /></li>' +
            '</ul>' +
            '</div>' +
            '</form>');
            $('form.create_multitrack_tag input:text').each(function(){//make input value of inputs feint
              $(this).addClass("feint");
            });
          return false;
        }
      }
    },//end create_tag
    this.delete_multitrack_tag_form_row = function(){
      $('.clear').live('click', function(){
        var form_row = $(this).parents('form.create_multitrack_tag');
        $(form_row).fadeOut(300);
      })
    },//end delete_multitrack_tag_form_row
    
    this.save_multitrack_tag = function(){
      $('form.create_multitrack_tag').live('submit',function(){
            $.ajax({
              type: 'post',
              url: '/multitrack_tags/',
              data: $(this).serialize(),
              dataType: 'json',
              error: function(res) { 
                var errors = JSON.parse(res.responseText);
                
                var error_list = $('<ul>');
                var error_container = $('#error_container');
                error_container.html('');
                
                for(var i=0, j=errors.length; i < j; i++){
                  $('<li>' + errors[i] + '</li>').appendTo(error_list);
                }
                
                error_list.appendTo(error_container);
                error_container.slideDown(400);
                setTimeout(function(){
                  error_container.slideUp(500);
                }, 8000);
                
              },
              success: function(res){
                var multitrack_tag = res.multitrack_tag;              
                var previous_class, next_class;             
                previous_class = $('table#multitrack-tags-table tbody tr:last-child').attr('class');             
                if( previous_class.match(/even/) ) {
                  next_class = 'odd';
                } else {
                  next_class = 'even';
                }             
                var new_row = $('<tr><td><a href="/multitrack_tags/' + multitrack_tag.id + '">' + multitrack_tag.hook + '</a></td>' +
                      '<td>' + multitrack_tag.location + '</td>' + 
                      '<td>' + multitrack_tag.description + '</td>' + 
                      '<td>MultitrackTag</td>' +
                      '<td><a class="delete button" href="/multitrack_tags/'+ multitrack_tag.id +'">Delete</a></td></tr>d');
                      
                new_row.insertAfter($('table#multitrack-tags-table tbody tr:last-child'));
                new_row.addClass(next_class);
                $('form.create_multitrack_tag').find(':input:text').each(function(){
                  $(this).val(''); //clear the inputs
                });
              }//end success
            });//end ajax
            return false;
          // }//end if
        // })//end each
      })//end live
    }//end save_multitrack_tag
    
  }//end MultitrackTag object
  window.PRIMEDIA.MultitrackTag = MultitrackTag;

})();

$(document).ready(function() {
  
  var kvp = new PRIMEDIA.KeyValueForm();
  kvp.create_key_val();
  kvp.feint_input_value();
  
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
    
});
