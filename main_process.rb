require 'rubygems'
require_relative 'workflow'
require_relative 'crawler'
require 'Date'
require_relative 'csv_writer'

MAIN_WEBSITE_URL = 'http://www.taobao.com/'
KEY_WORD         = ['微熱山丘']
# main = WorkFlow.new
# main.start
KEY_WORD.each do |key_word|
  file_name  = 'daily.csv'
  start_date = '2015-02-21'
  crawler    = Crawler.new(MAIN_WEBSITE_URL, key_word, start_date: start_date, end_date: '2015-02-14')
  crawler.start_parse

  sellers_data = crawler.sellers_data

  crawler.close

  CsvWriter.call_daily_report(sellers_data, key_word + file_name, start_date)
  CsvWriter.call_detail_daily_report(sellers_data, "#{key_word}_detail_report.csv", start_date)
  CsvWriter.big_amount_format(sellers_data, "#{key_word}big_amount.csv", start_date)
end
