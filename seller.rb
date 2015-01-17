# This class is dealing with the data structure of the seller data

require 'data_analyzer'

class Seller

  attr_accessor :name
  attr_reader :data_analyzer

  def initialize(records)
    @data_analyzer = DataAnalyzer.new(records)
    @name          = data_analyzer.seller_name
  end

  def daily_amount(date)
    @daily_amount ||= data_analyzer.daily_amount(date)
  end

  def weekly_amount(start_date)
    @weekly_amount ||= duration_amount(start_date, start_date+7)
  end

  def duration_amount(start_date, end_date)
    data_analyzer.duration_amount(start_date, end_date)
  end

  def average_price
    @average_price ||= data_analyzer.average_price
  end

  def total_record
    @total_record ||= data_analyzer.records.size
  end

  # return the amount of product box
  def total_amount
    @total_amount ||= data_analyzer.total_amount
  end
end