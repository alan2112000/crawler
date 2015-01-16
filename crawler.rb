require 'nokogiri'
require 'open-uri'
require 'watir-webdriver'


# This Class is used to crawler the data in taobo by keyword
class Crawler

  def self.call(url)
    browswer = Watir::Browser.new
    browswer.goto url
    sleep(5)

    doc = Nokogiri::HTML(browswer.html)
    item = doc.css('li.item')

    seller = item[0]
    a_link = item[0].css('a')[0]['href']
    browswer.goto a_link







    # puts doc
    # btn = browswer.a(:class => 'J_ItemPic')
    # if btn.exists?
    #   puts 'link exists'
    #   btn.click
    # end



  end

end