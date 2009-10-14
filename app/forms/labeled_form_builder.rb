class LabeledFormBuilder < ActionView::Helpers::FormBuilder
  
  [:text_field, :password_field, :file_field, :text_area].each do |method_name|
    define_method method_name do |name, *args|
      options = args.extract_options!
      with_label(name) do
        has_errors = object.errors.on(name)
        if has_errors
          options.merge! :class => "input_error"
        end
        super(name, options)
      end
    end
  end

  private
  
  
  def with_label(name)
    @template.content_tag(:p, label(name) + yield)
  end
  
end