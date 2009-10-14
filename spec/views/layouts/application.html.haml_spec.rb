require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "layouts/application" do
 
  before :each do
    @products = ["AG", "RH", "NHG"].map { |name| mock_model(Product, :name => name) } 
    assigns[:products] = @products
    template.stub!(:logged_in?).and_return(true)
  end

  def do_render
    render "layouts/application"
  end
  
  it "should render a logout link if the user is logged in" do
    do_render
    response.should have_tag("a", /logout/i)
  end

  it "should not render a logout link if the user is logged in" do
    template.stub!(:logged_in?).and_return(false)
    do_render
    response.should_not have_tag("a", /logout/i)
  end
  
  it "should not show product links if user is not logged in" do
    template.stub!(:logged_in?).and_return(false)
    do_render
    @products.each do |product|
      response.should_not have_tag("a[href=?]", product_path(product))
    end
  end

  it "should show product links if user is logged in" do
    do_render
    @products.each do |product|
      response.should have_tag("a[href=?]", product_path(product))
    end
  end
  
  
 
 
end