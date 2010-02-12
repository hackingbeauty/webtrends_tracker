module ApplicationHelper
  
  def show_flashes
    retval = ""
    for name in [:notice, :warning, :message, :error]
      if flash[name]
       retval += "<div class=\"flash\ flash_#{name}\"><span>#{flash[name]}</span></div>"
      end
    end
    retval
  end
  
  
end
