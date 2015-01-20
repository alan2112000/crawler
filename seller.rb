# This class is dealing with the data structure of the seller data

require_relative 'data_analyzer'

class Seller

  attr_accessor :name, :item_counter, :deal_people_counter, :deal_counter, :records

  # expect to pass record of array
  def initialize(seller_name, item_counter, deal_counter, records)
    @records      = records
    @name         = seller_name
    @item_counter = item_counter
    @deal_counter = deal_counter
    @deal_people_counter = deal_people_counter || 0
  end

  def daily_amount(date)
    DataAnalyzerService.daily_amount(records, date)
  end

  def weekly_amount(start_date)
    @weekly_amount ||= duration_amount(start_date, start_date+7)
  end

  def duration_amount(start_date, end_date)
    DataAnalyzerService.duration_amount(records, start_date, end_date)
  end

  def average_price
    @average_price ||= DataAnalyzerService.average_price(records)
  end

  def total_record
    @total_record ||= DataAnalyzerService.records.size
  end

  # return the amount of product box
  def total_amount
    @total_amount ||= DataAnalyzerService.total_amount(records)
  end

end