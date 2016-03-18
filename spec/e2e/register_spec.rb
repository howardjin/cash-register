
require 'cash/register'
require 'cash/product'
require 'json'

describe Register do

  context 'items with no discount' do

    it 'single item' do

      product = Product.new
      product.id = 'ITEM000001'
      product.name = '可口可乐'
      product.unit_price = 3.00

      subject.registerItems([product])

      results = subject.generateReceipts("['ITEM000001']")
      expect(results[0]).to eq '***<没赚钱商店>购物清单***'
      expect(results[1]).to eq '名称:可口可乐,数量:1瓶,单价:3.00(元),小计:3.00(元)'
      expect(results[2]).to eq '------------------'
      expect(results[3]).to eq '总计:3.00(元)'
      expect(results[4]).to eq '******************'

    end

    it 'item with count' do

      product = Product.new
      product.id = 'ITEM000001'
      product.name = '可口可乐'
      product.unit_price = 3.00

      subject.registerItems([product])

      results = subject.generateReceipts("['ITEM000001-2']")
      expect(results[0]).to eq '***<没赚钱商店>购物清单***'
      expect(results[1]).to eq '名称:可口可乐,数量:2瓶,单价:3.00(元),小计:6.00(元)'
      expect(results[2]).to eq '------------------'
      expect(results[3]).to eq '总计:6.00(元)'
      expect(results[4]).to eq '******************'

    end

  end

end