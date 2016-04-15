require 'cash/product'
require 'cash/line_item'
require 'cash/discount'
require 'rspec/its'

describe LineItem  do
  let(:product) do
    product = Product.new
    product.unit_price = 1.0
    product
  end

  subject { LineItem.new(product, count, discount) }

  context 'no discount' do
    let(:count) { 2 }
    let(:discount) { DiscountCalculator.NoDiscount }
    its(:total_price) { should eq(2.0) }
    its(:saved_money) { should eq(0) }
    its(:product_count_for_free) {should eq(0)}
  end

  context  'buy 2 free 1' do
    context 'should calculate 2 products with 1 free when buy 3 products' do
      let(:count) { 3 }
      let(:discount) { DiscountCalculator.Buy2Get1Free }
      its(:total_price) { should eq(2.0) }
      its(:saved_money) { should eq(1.0) }
      its(:product_count_for_free) {should eq(1)}
      its(:product_count_for_free) {should be_an(Integer)}
    end

    context 'should calculate 3 products with 1 free when buy 4 products' do
      let(:count) { 4 }
      let(:discount) { DiscountCalculator.Buy2Get1Free }
      its(:total_price) { should eq(3.0) }
      its(:saved_money) { should eq(1.0) }
      its(:product_count_for_free) {should eq(1)}
    end

    context 'should calculate 4 products with 1 free when buy 5 products' do
      let(:count) { 5 }
      let(:discount) { DiscountCalculator.Buy2Get1Free }
      its(:total_price) { should eq(4.0) }
      its(:saved_money) { should eq(1.0) }
      its(:product_count_for_free) {should eq(1)}
    end
  end
end