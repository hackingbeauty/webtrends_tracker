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
  
  def total_tags
    total_tags = Tag.find(:all).size
    total_tags.to_s
  end
  
  def total_multitrack_tags
    total_multitrack_tags = MultitrackTag.find(:all).size
    total_multitrack_tags.to_s
  end
  
  def total_page_view_tags
    total_page_view_tags = PageViewTag.find(:all).size
    total_page_view_tags.to_s
  end
  
end
