require 'rails_helper'

RSpec.describe "purchases/show", type: :view do
  before(:each) do
    assign(:purchase, Purchase.create!(
      item_name: "Item Name",
      item_id: 2,
      price: "9.99",
      weight: "9.99",
      company_id: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Item Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/3/)
  end
end
