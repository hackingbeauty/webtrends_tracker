class LabeledFormBuilder < ActionView::Helpers::FormBuilder
  
  def text_field(name, options={})
    with_label(name) do
      super(name, options)
    end
  end
  
  def password_field(name, options={})
    with_label(name) do
      super(name, options)
    end
  end
  
  private
  
  def with_label(name)
    @template.content_tag(:p, label(name) + yield)
  end
  
end