require 'rails_helper'

RSpec.describe "purchases/index", type: :view do
  before(:each) do
    assign(:purchases, [
      Purchase.create!(
        item_name: "Item Name",
        item_id: 2,
        price: "9.99",
        weight: "9.99",
        company_id: 3
      ),
      Purchase.create!(
        item_name: "Item Name",
        item_id: 2,
        price: "9.99",
        weight: "9.99",
        company_id: 3
      )
    ])
  end

  it "renders a list of purchases" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Item Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
