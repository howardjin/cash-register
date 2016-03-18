require 'json'

class LineItem
  attr_accessor :product, :count

  def initialize(product, count)
    @product = product
    @count = count
  end
end

class Register

  def generateReceipts(inputs)
    inputJson = JSON.parse(convert_to_valid_json(inputs))
    inputJsonItem = inputJson[0]
    lineItemParts = inputJsonItem.split('-')

    if(lineItemParts[1].nil?)
      count = 1
    elsif
      count = lineItemParts[1].to_i
    end
    receipts  = []
    product = @items.detect { |item| item.id == lineItemParts[0]}
    lineItem = LineItem.new(product,count)
    add_header(receipts)
    add_line_items(receipts, lineItem)
    add_separator(receipts)
    add_summary(product, receipts, count)
    add_footer(receipts)
    receipts
  end

  def convert_to_valid_json(inputs)
    inputs.tr("'", '"')
  end

  def add_line_items(receipts, lineItem)
    receipts << "名称:#{lineItem.product.name},数量:#{lineItem.count}瓶,单价:#{formatPrice(lineItem.product.unit_price)}(元),小计:#{formatPrice(lineItem.product.unit_price * lineItem.count)}(元)"
  end

  def add_summary(product, receipts, count)
    receipts << "总计:#{formatPrice(product.unit_price * count)}(元)"
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