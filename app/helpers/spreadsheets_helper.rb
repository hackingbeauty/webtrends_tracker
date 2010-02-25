module SpreadsheetsHelper
  def create_csv(products)
    all_tags = products.map(&:tags).flatten
    
    return "Nothing to report" unless all_tags.first
    
    all_kvps = all_tags.map(&:key_value_pairs).flatten.sort_by {|x| x.key }
    key_names = all_kvps.map(&:key).uniq
    
    retval = "product,type,hook,location,description," + key_names.join(',') + "\n"
    
    for product in products
      for tag in product.tags
        retval += tag_row(tag, key_names)
      end
    end
    
    retval
  end
  
  private
  
  def tag_row(tag, key_names)
    row = [
      tag.product.name || '-', 
      tag.type         || '-', 
      tag.hook         || '-', 
      tag.location     || '-', 
      tag.description  || '-'
    ]
    key_names.each { |key| row << tag.value_str(key) }    
    row.join(',') + "\n"
  end
end