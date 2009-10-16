require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "tags/show" do
  
  before do
    # set up your tag
    @tag = Tag.new({
      :hook => 'wt_ag_0001',
      :location => 'somewhere',
      :description => 'somewhere out there',
      :product => Product.new(:name => "Apartment Guide")
    })

    @tag.key_value_pairs.build :key => "WT.dl" , :value => "1"
    @tag.key_value_pairs.build :key => "NAME" , :value => "DYNAMIC"
    
    assigns[:tag] = @tag
    render "tags/show"
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
      with_tag("input[type=file][name=?]", "tag[snapshot]")
      with_tag("input[type=submit]")
    end
  end
  
  it "should render a table with the values for the tag hook, location, description" do
    response.should have_tag("table") do
      with_tag("tr") do
        with_tag("td", /hook/i)
        with_tag("td", @tag.hook)
      end
      with_tag("tr") do
        with_tag("td", /location/i)
        with_tag("td", @tag.location)
      end
      with_tag("tr") do
        with_tag("td", /description/i)
        with_tag("td", @tag.description)
      end
    end
  end
  
  it "should render a table with the values for the key value pairs" do
    response.should have_tag("table") do
      with_tag("tr") do
        with_tag("td", "WT.dl")
        with_tag("td", "1")
      end
      with_tag("tr") do
        with_tag("td", "NAME")
        with_tag("td", "DYNAMIC")
      end
    end
  end
  
end