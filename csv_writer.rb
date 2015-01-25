# encoding : utf-8
require 'csv'

WEEKLY_REPORT_COLUMN_NAME = %w[Rank Seller Average-Price Received_People Item-Sold-in-30days, Transaction_Number]
DAILY_REPORT_COLUMN_NAME  = %w[Date Amount Price Buyer, title, Product_Name, Size]
WEEKLY_REPORT_SELLER_INFO = %W[Seller_Name Average_Price Received_People Transaction_Number Success_Sold Total_Amount Product_Size]

DAILY_TOTAL_REPORT_COLUMN = %w[Date Amount Price]
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


  # Output the date of records in every seller
  def self.call_daily_report(sellers_data, file_name, date)

    sellers_data.sort_by! { |seller| seller.success_sold_counter}
    date = Date.parse(date)
    # head = 'EF BB BF'.split(' ').map{|a|a.hex.chr}.join()
    CSV.open("#{date}_#{file_name}", 'w') do |csv|
      sellers_data.each do |seller|
        csv << WEEKLY_REPORT_SELLER_INFO
        puts seller.name
        start_date = date - 6
        csv << seller_info(seller)
        # records = seller.records.sort_by { |record| record.date }


        csv << DAILY_TOTAL_REPORT_COLUMN
        7.times do
          csv << daily_format2(start_date, seller.daily_amount(start_date), seller.average_price(seller.records_by_date(start_date)))
          start_date += 1
        end
      end
    end
  end

  # return a weekly report in a row array
  def self.weekly_format(seller, rank)
    [rank, 'shop name', seller.average_price, seller.number_of_received_people, seller.item_counter, seller.deal_counter]
  end

  def self.daily_format(record)
    [record.date, record.amount, record.unit_price, record.buyer_name, record.title, record.product_name, record.size]
  end

  def self.seller_info(seller)
    [seller.name, seller.average_price, seller.number_of_received_people, seller.deal_counter, seller.success_sold_counter, seller.total_amount, seller.product_size]
  end

  def self.daily_format2(date, amount, average_price)
    [date, amount, average_price]
  end

end