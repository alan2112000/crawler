require 'rubygems'
require_relative 'crawler'
require 'Date'
require_relative 'csv_writer'


url = 'http://s.taobao.com/search?initiative_id=tbindexz_20150116&tab=all&q=%CE%A2%9F%E1%C9%BD%C7%F0&sort=sale-desc'

crawler = Crawler.new(url, start_date: '2015-01-17', end_date: '2015-01-11')
crawler.start_parse

sellers_data = crawler.sellers_data
crawler.close

CsvWriter.call(sellers_data, 'testFile.csv')
