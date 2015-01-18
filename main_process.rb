require_relative 'crawler'
require 'Date'


url     = 'http://s.taobao.com/search?initiative_id=tbindexz_20150116&tab=all&q=%CE%A2%9F%E1%C9%BD%C7%F0&sort=sale-desc'

item_url = 'http://item.taobao.com/item.htm?spm=a230r.1.14.1.PO9xTu&id=15512619980&ns=1&abbucket=15#detail'
crawler = Crawler.new(url,start_date: '2015-01-18', end_date: '2015-01-17')
crawler.start_parse





