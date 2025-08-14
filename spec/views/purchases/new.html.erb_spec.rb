require 'rails_helper'

RSpec.describe "purchases/new", type: :view do
  before(:each) do
    assign(:purchase, Purchase.new(
      item_name: "MyString",
      item_id: 1,
      price: "9.99",
      weight: "9.99",
      company_id: 1
    ))
  end

  it "renders new purchase form" do
    render

    assert_select "form[action=?][method=?]", purchases_path, "post" do

      assert_select "input[name=?]", "purchase[item_name]"

      assert_select "input[name=?]", "purchase[item_id]"

      assert_select "input[name=?]", "purchase[price]"

      assert_select "input[name=?]", "purchase[weight]"

      assert_select "input[name=?]", "purchase[company_id]"
    end
  end
end
