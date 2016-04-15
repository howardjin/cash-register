require 'cash/discount'

class LineItem

  attr_reader :count

  def self.fromString(itemString, products, buy_two_free_one_item_ids)
    lineItemParts = itemString.split('-')

    if(lineItemParts[1].nil?)
      count = 1
    elsif
    count = lineItemParts[1].to_i
    end
    product = products.detect { |item| item.id == lineItemParts[0]}
    if(buy_two_free_one_item_ids.include? lineItemParts[0])
      LineItem.new(product, count, DiscountCalculator.Buy2Get1Free)
    else
      LineItem.new(product, count)
    end

  end

  def initialize(product, count, discount = DiscountCalculator.NoDiscount)
    @product = product
    @count = count
    @discount = discount
  end

  def product_name
    @product.name
  end

  def product_unit_price
    @product.unit_price
  end

  def product_unit_name
    @product.unit_name
  end

  def total_price
    @product.unit_price * @count - @discount.discount(self)
  end

  def saved_money
    @discount.discount(self)
  end

  def product_count_for_free
    (@discount.discount(self) / @product.unit_price).to_i
  end
end