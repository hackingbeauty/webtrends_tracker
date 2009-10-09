module ApplicationHelper
  
  def show_flashes
    retval = ""
    for name in [:notice, :warning, :message, :error]
      if flash[name]
       retval += "<div class=\"flash\ flash_#{name}\"><h3>#{name.to_s.titleize}:</h3><span>#{flash[name]}</span></div>"
      end
    end
    retval
  end
  
  def tag_sort_link(order)
    flipped_order = (order == 'created_at desc') ? 'asc' : 'desc'
    path = url_for(:controller => params[:controller], :action => params[:action], :order => flipped_order)
    if flipped_order == "asc"
      return link_to "Date created &darr;", path
    else
      return link_to "Date created &uarr;", path
    end
  end
  
end
