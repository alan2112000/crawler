require 'rubygems'
require_relative 'crawler'
require 'Date'
require_relative 'csv_writer'

MAIN_WEBSITE_URL = 'http://www.taobao.com/'
KEY_WORD = '微熱山丘'

crawler = Crawler.new(MAIN_WEBSITE_URL, KEY_WORD, start_date: '2015-01-24', end_date: '2015-01-17')
crawler.start_parse

sellers_data = crawler.sellers_data

crawler.close

CsvWriter.call_daily_report(sellers_data, 'daily.csv', '2015-01-24' )