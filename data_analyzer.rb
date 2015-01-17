# This class is used to analyze the recrods by each seller

class DataAnalyzer

  attr_accessor :records

  def initialize(records)
    @records = records
  end

  def daily_amount(date)
    records.map { |record| record if record.date == date }
  end

  def seller_name
    @seller_name ||= records.present? ? records.first.seller_name : 'There is no reocrds'
  end

  def average_price
    money = records.each_with_object(0) { |record, money| money += record.unit_price }
    return (money/records.size)
  end

  # 購買數量的盒數
  def total_amount
    records.each_with_object(0) { |record, amount| amount += record.amount }
  end

  def duration_amount(start_date, end_date)
    days   = end_date - start_date
    amount = 0

    days.times do |time|
      amount += daily_amount(start_date + time)
    end
    return amount
  end

end

