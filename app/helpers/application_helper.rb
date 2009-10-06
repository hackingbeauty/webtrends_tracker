# Methods added to this helper will be available to all templates in the application.
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
  
end
