require 'rubygems'
require 'json'
require 'cash/line_item'
require 'active_support'

class Register

  def get_line_items(inputs)
    inputJson = JSON.parse(convert_to_valid_json(inputs))
    inputJson.map { |jsonItem| LineItem.fromString(jsonItem, @items) }
  end


  def generateReceipts(inputs)
    lineItems = get_line_items(inputs)
    receipts  = []
    add_header(receipts)
    add_line_items(receipts, lineItems)
    add_separator(receipts)
    add_summary(receipts, lineItems)
    add_footer(receipts)
    receipts
  end

  def convert_to_valid_json(inputs)
    inputs.tr("'", '"')
  end

  def add_line_items(receipts, lineItems)
    lineItems.each do |lineItem|
      receipts << "名称:#{lineItem.product_name},数量:#{lineItem.count}#{lineItem.product_unit_name},单价:#{formatPrice(lineItem.product_unit_price)}(元),小计:#{formatPrice(lineItem.total_price)}(元)"
    end
  end

  def add_summary(receipts, lineItems)
    total_price = lineItems.map(&:total_price).reduce(0, :+)
    receipts << "总计:#{formatPrice(total_price)}(元)"
  end

  def add_separator(receipts)
    receipts << '------------------'
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

end