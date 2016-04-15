require 'rubygems'
require 'json'
require 'cash/line_item'
require 'active_support'

class Register

  def initialize
    @buy_two_free_one_item_ids = []
  end

  def get_line_items(inputs)
    inputJson = JSON.parse(convert_to_valid_json(inputs))
    inputJson.map { |jsonItem| LineItem.fromString(jsonItem, @items, @buy_two_free_one_item_ids) }
  end

  def generateReceipts(inputs)
    lineItems = get_line_items(inputs)
    print_receipt(
        lambda { generate_line_items(lineItems) },
        lambda { generate_free_items(lineItems) },
        lambda { generate_summary(lineItems) })
  end

  def print_receipt(section1, section2, section3)
    receipts = []
    add_header(receipts)
    receipts.push(*section1.call)
    add_separator(receipts)
    receipts.push(*section2.call)
    add_separator(receipts)
    receipts.push(*section3.call)
    add_footer(receipts)
    receipts
  end

  def generate_free_items(lineItems)
    receipts = []
    discount_items = lineItems.select { |item| item.product_count_for_free > 0 }
    if discount_items.length > 0
      receipts << '买二赠一商品:'
      discount_items.each do |item|
        receipts << "名称:#{item.product_name},数量:#{item.product_count_for_free}#{item.product_unit_name}"
      end
    end
    receipts
  end

  def generate_saved_money(lineItems)
    total_discount = lineItems.map(&:saved_money).reduce(0, :+)
    if total_discount > 0
      "节省:#{formatPrice(total_discount)}(元)"
    end
  end

  def convert_to_valid_json(inputs)
    inputs.tr("'", '"')
  end

  def generate_line_items(lineItems)
    lineItems.map do |lineItem|
      "名称:#{lineItem.product_name},数量:#{lineItem.count}#{lineItem.product_unit_name},单价:#{formatPrice(lineItem.product_unit_price)}(元),小计:#{formatPrice(lineItem.total_price)}(元)"
    end
  end

  def generate_summary(lineItems)
    saved_money = generate_saved_money(lineItems)
    receipts = [generate_total_money(lineItems)]
    if saved_money
      receipts << saved_money
    end
    receipts
  end

  def generate_total_money(lineItems)
    total_price = lineItems.map(&:total_price).reduce(0, :+)
    "总计:#{formatPrice(total_price)}(元)"
  end

  def add_separator(receipts)
    separator = '------------------'
    if receipts.last != separator
      receipts << separator
    end
  end

  def add_footer(receipts)
    receipts << '******************'
  end

  def add_header(receipts)
    receipts << '***<没赚钱商店>购物清单***'
  end

  def registerItems(items)
    @items = items
  end

  def formatPrice(price)
    sprintf('%.2f', price)
  end

  def registerBuyTwoGetOneFreeDiscounts(buy_two_free_one_item_list)
    @buy_two_free_one_item_ids = JSON.parse(buy_two_free_one_item_list)
  end

end