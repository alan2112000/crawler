# Transaction Record

class Record

  attr_accessor :product_name, :unit_price, :amount, :date, :seller_name, :buyer_name, :title

  def initialize(data = {})
    recordify(data)
  end

  def total_price
    unit_price * amount
  end

  private

  def recordify(data)
    @product_name = data.fetch(:product_name, 'No Product Name')
    @unit_price   = data.fetch(:unit_price, nil)
    @amount       = data.fetch(:amount, nil)
    @seller_name  = data.fetch(:seller_name, nil)
    @buyer_name   = data.fetch(:buyer_name, nil)
  end
end