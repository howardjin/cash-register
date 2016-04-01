require 'cash/product'
require 'cash/line_item'
require 'cash/discount'

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
    it 'should return total price' do
      expect(subject.total_price).to eq 2.0
    end
  end

  context  'buy 2 free 1' do
    let(:count) { 3 }
    let(:discount) { DiscountCalculator.Buy2Get1Free }
    it 'should return total price with discount' do
      expect(subject.total_price).to eq 2.0
    end
  end

end