# Transaction Record

class Record

  attr_accessor :product_name, :unit_price, :amount, :date, :seller_name, :buyer_name, :title, :size

  def initialize(data = {})
    recordify(data)
  end

  def total_price
    unit_price * amount
  end

  private

  def recordify(data)
    @product_name = data.fetch(:product_name, 'No Product Name')
    @unit_price   = data.fetch(:unit_price, 0)
    @amount       = data.fetch(:amount, 0)
    @seller_name  = data.fetch(:seller_name, nil)
    @buyer_name   = data.fetch(:buyer_name, nil)
    @date         = data.fetch(:date, nil)
    @size         =data.fetch(:size, 0)
  end
end