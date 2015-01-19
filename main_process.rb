require_relative 'crawler'
require 'Date'


url     = 'http://s.taobao.com/search?initiative_id=tbindexz_20150116&tab=all&q=%CE%A2%9F%E1%C9%BD%C7%F0&sort=sale-desc'

crawler = Crawler.new(url, start_date: '2015-01-18', end_date: '2015-01-17')
crawler.start_parse
sellers_data = crawler.sellers_data
crawler.close



date_string = %w[2015-01-18 2015-01-17 2015-01-16 2015-01-15 2015-01-14 2015-01-13 2015-01-12 2015-01-11]

# date_string = %w[2015-01-18]

# date_string.each do |date|
  date = Date.parse('2015-01-18')
  sellers_data.each do |seller|
    daily_amount = seller.daily_amount(date)
    average_price = seller.average_price
    puts "Seller Name : #{seller.name} Date: #{date} Amount : #{daily_amount}, average price: #{average_price}"
  end
# end