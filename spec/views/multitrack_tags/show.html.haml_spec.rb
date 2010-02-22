require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "multitrack_tags/show" do
  
  before do
    # @tag = mock('multitrack_tag',
    #   :hook => 'wt_ag_0001',
    #   :location => 'somewhere',
    #   :description => 'somewhere out there',
    #   :product => mock('product', :name => "Apartment Guide", :abbreviation => "ag"),
    #   :key_value_pairs => [
    #     mock('kvp', :key => 'WT.dl', :value => '1', :id => '123'),
    #     mock('kvp', :key => 'foo', :value => 'bar', :id => '456'),
    #   ]
    # )
    
    # set up your tag
    @tag = MultitrackTag.create!({
      :hook => 'wt_ag_0001',
      :location => 'somewhere',
      :description => 'somewhere out there',
      :product => Product.new(:name => "Apartment Guide", :abbreviation => "ag")
    })

    @tag.key_value_pairs.create :key => "NAME", :value => "DYNAMIC"
    
    assigns[:tag] = @tag
    render "multitrack_tags/show"
  end
  
  it "should render something" do
    response.body.should_not be_blank
  end
  
  it "should render a form for the new key value pair" do
    response.should have_tag("form[action=?]", key_value_pairs_path) do
      with_tag("input[type=text][name=?]", "key_value_pair[key]")
      with_tag("input[type=text][name=?]", "key_value_pair[value]")
      with_tag("input[type=submit]")
    end
  end
  
  it "should render a form for the new snapshot" do
    response.should have_tag("form[action=?][enctype=?]", screen_shots_path, "multipart/form-data") do
      with_tag("input[type=file][name=?]", "multitrack_tag[snapshot]")
      with_tag("input[type=submit]")
    end
  end
    
  it "should render a table with the values for the key value pairs" do
    response.should have_tag("table") do
      with_tag("tr") do
        with_tag("td", "WT.dl")
        with_tag("td", "dcsuri")
        with_tag("a", /delete/i)
      end
      with_tag("tr") do
        with_tag("td", "NAME")
        with_tag("td", "DYNAMIC")
      end
    end
  end
  
end