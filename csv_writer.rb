# encoding : utf-8
require 'csv'

WEEKLY_REPORT_COLUMN_NAME = %w[Rank Seller Average-Price Buyer-Counter Sell-Counter Item-Sold-in-30days]
DAILY_REPORT_COLUMN_NAME  = %w[Date Amount Price Buyer]
# Handling the csv output
class CsvWriter
  def self.call(sellers_data, file_name)

    CSV.open(file_name, 'w') do |csv|
      csv << WEEKLY_REPORT_COLUMN_NAME
      rank = 1
      sellers_data.each do |seller|
        puts "Seller Name: #{seller.name}"
        csv << weekly_format(seller, rank)
        rank += 1
      end
    end
  end


  def self.call_daily_report(sellers_data, file_name)
    CSV.open(file_name, 'w') do |csv|
      csv << DAILY_REPORT_COLUMN_NAME
      sellers_data.each do |seller|
        csv << daily_format(seller, date)
      end
    end
  end

  # return a weekly report in a row array
  def self.weekly_format(seller, rank)
    [rank, 'shop name', seller.average_price, seller.deal_people_counter, seller.item_counter, seller.deal_counter]
  end


  def self.daily_format(seller, date)
    [seller.name]
  end
end