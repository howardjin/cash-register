
require 'cash/register'
require 'cash/product'
require 'json'

describe Register do

  context 'no discount' do

    it 'print when line item string contains only product id' do

      product = Product.new
      product.id = 'ITEM000001'
      product.name = '可口可乐'
      product.unit_name = '瓶'
      product.unit_price = 3.00

      subject.registerItems([product])

      results = subject.generateReceipts("['ITEM000001']")
      expect(results[0]).to eq '***<没赚钱商店>购物清单***'
      expect(results[1]).to eq '名称:可口可乐,数量:1瓶,单价:3.00(元),小计:3.00(元)'
      expect(results[2]).to eq '------------------'
      expect(results[3]).to eq '总计:3.00(元)'
      expect(results[4]).to eq '******************'

    end

    it 'print when line item string contains product id as well as number' do

      product = Product.new
      product.id = 'ITEM000001'
      product.name = '可口可乐'
      product.unit_name = '瓶'
      product.unit_price = 3.00

      subject.registerItems([product])

      results = subject.generateReceipts("['ITEM000001-2']")
      expect(results[0]).to eq '***<没赚钱商店>购物清单***'
      expect(results[1]).to eq '名称:可口可乐,数量:2瓶,单价:3.00(元),小计:6.00(元)'
      expect(results[2]).to eq '------------------'
      expect(results[3]).to eq '总计:6.00(元)'
      expect(results[4]).to eq '******************'

    end

    it 'print when having multiple line items' do
      coke = Product.new
      coke.id = 'ITEM000001'
      coke.name = '可口可乐'
      coke.unit_name = '瓶'
      coke.unit_price = 3.00

      badminton = Product.new
      badminton.id = 'ITEM000002'
      badminton.name = '羽毛球'
      badminton.unit_name = '个'
      badminton.unit_price = 1.00

      subject.registerItems([coke, badminton])

      results = subject.generateReceipts("['ITEM000001-2', 'ITEM000002-2']")
      expect(results[0]).to eq '***<没赚钱商店>购物清单***'
      expect(results[1]).to eq '名称:可口可乐,数量:2瓶,单价:3.00(元),小计:6.00(元)'
      expect(results[2]).to eq '名称:羽毛球,数量:2个,单价:1.00(元),小计:2.00(元)'
      expect(results[3]).to eq '------------------'
      expect(results[4]).to eq '总计:8.00(元)'
      expect(results[5]).to eq '******************'
    end
  end

end