require 'rubygems'
require_relative 'workflow'
require_relative 'crawler'
require 'Date'
require_relative 'csv_writer'

MAIN_WEBSITE_URL = 'http://www.taobao.com/'
KEY_WORD = '微熱山丘'
# main = WorkFlow.new
# main.start
crawler = Crawler.new(MAIN_WEBSITE_URL, KEY_WORD, start_date: '2015-01-28', end_date: '2015-01-27')
crawler.start_parse

sellers_data = crawler.sellers_data

crawler.close

CsvWriter.call_daily_report(sellers_data, 'daily.csv', '2015-01-28' )
CsvWriter.call_detail_daily_report(sellers_data, 'detail_report.csv', '2015-01-28')
