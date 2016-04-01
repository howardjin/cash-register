require 'cash/discount_type'

class DiscountCalculator

  def self.NoDiscount
    DiscountCalculator.new(DiscountType::NoDiscount)
  end

  def self.Buy2Get1Free
    DiscountCalculator.new(DiscountType::Buy2Get1Free)
  end

  def initialize(discount_type)
    @discount_type = discount_type
  end

  def discount(line_item)

    case @discount_type

      when DiscountType::Buy2Get1Free
        line_item.product_unit_price * (line_item.count / 3)
      else
        0
    end

  end

end