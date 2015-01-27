# encoding : utf-8
require 'csv'

WEEKLY_REPORT_COLUMN_NAME = %w[Rank Seller Average-Price Received_People Item-Sold-in-30days, Transaction_Number]
DAILY_REPORT_COLUMN_NAME  = %w[日期 數量 價格 買家 產品名 容量]
WEEKLY_REPORT_SELLER_INFO = %W[賣家 平均價格 收貨人數 成交件數 成功賣出件數 總數 產品名 容量]
DAILY_TOTAL_REPORT_COLUMN = %w[日期 數量 價格]

# Handling the name of the column and the format of the csv output
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

    sellers_data.sort_by! { |seller| seller.success_sold_counter.to_i }
    date = Date.parse(date)
    CSV.open("#{date}_#{file_name}", 'w') do |csv|
      sellers_data.each do |seller|
        csv << WEEKLY_REPORT_SELLER_INFO
        puts seller.name
        start_date = date - 6
        csv << seller_info(seller)
        csv << DAILY_TOTAL_REPORT_COLUMN
        7.times do
          csv << daily_format2(start_date, seller.daily_amount(start_date), seller.average_price(seller.records_by_date(start_date)))
          start_date += 1
        end
      end
    end
  end

  def self.call_detail_daily_report(sellers_data, file_name, date)
    sellers_data.sort_by! { |seller| seller.success_sold_counter }
    date = Date.parse(date)
    CSV.open("#{date}_#{file_name}", 'w') do |csv|
      sellers_data.each do |seller|
        csv << WEEKLY_REPORT_SELLER_INFO
        puts seller.name
        csv << seller_info(seller)
        records = seller.records.sort_by { |record| record.date }
        csv << DAILY_REPORT_COLUMN_NAME
        records.each do |record|
          csv << daily_format(record)
        end
      end
    end
  end

  # return a weekly report in a row array
  def self.weekly_format(seller, rank)
    [rank, 'shop name', seller.average_price, seller.number_of_received_people, seller.item_counter, seller.deal_counter]
  end

  def self.daily_format(record)
    [record.date, record.amount, record.unit_price, record.buyer_name, record.product_name, record.size]
  end

  def self.seller_info(seller)
    [seller.name, seller.average_price, seller.number_of_received_people, seller.deal_counter, seller.success_sold_counter, seller.total_amount, seller.product_title, seller.product_size]
  end

  def self.daily_format2(date, amount, average_price)
    [date, amount, average_price]
  end

end