# This class is dealing with the data structure of the seller data

require_relative 'data_analyzer'

class Seller

  attr_accessor :name, :success_sold_counter, :number_of_received_people, :deal_counter, :records

  # expect to pass record of array
  def initialize(seller_name, success_sold_counter, deal_counter, records, number_of_recieved_people = 0)
    @records                   = records
    @name                      = seller_name
    # 成功售出件數
    @success_sold_counter      = success_sold_counter || 0
    # 成交件數
    @deal_counter              = deal_counter
    # 收獲人數
    @number_of_received_people = number_of_received_people
  end

  def records_by_date(date)
    DataAnalyzerService.filter_by_date(@records, date)
  end

  def daily_amount(date)
    DataAnalyzerService.daily_amount(records, date)
  end

  def weekly_amount(start_date)
    duration_amount(start_date, start_date+6)
  end

  def duration_amount(start_date, end_date)
    DataAnalyzerService.duration_amount(records, start_date, end_date)
  end

  def average_price(records = @records)
    DataAnalyzerService.average_price(records)
  end

  def total_record
    @total_record ||= DataAnalyzerService.records.size
  end

  # return the amount of product box
  def total_amount
    @total_amount ||= DataAnalyzerService.total_amount(records)
  end

  def product_size
    return 0 unless records.first
    records.first.size
  end

end