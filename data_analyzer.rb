# This class is used to analyze the recrods by each seller

class DataAnalyzerService


  def self.average_price(records, option = {})
    return 0 if records.length == 0
    money = 0
    records.each { |record| money += record.unit_price.to_i }
    length = records.length
    return (money / length)
  end

  # 購買數量的盒數

  def self.duration_amount(records, start_date, end_date)
    days   = end_date - start_date
    amount = 0

    days.times do |time|
      amount += daily_amount(records, start_date + time)
    end
    return amount
  end

  def self.daily_amount(records, date)
    date_records = filter_by_date(records, date)
    total_amount(date_records)
  end

  def self.total_amount(records)
    return if records.empty?
    amount = 0
    records.each { |record| amount += record.amount.to_i}
    return amount
  end

  def self.filter_by_date(records, date)
    records.select { |record| record.date == date }
  end
end

