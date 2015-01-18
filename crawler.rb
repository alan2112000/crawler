require 'nokogiri'
require 'open-uri'
require 'watir-webdriver'
require 'Date'


# This Class is used to crawler the data in taobo by keyword
class Crawler

  attr_reader :url, :sellers_data, :seller_links, :item_url, :key_word, :browser, :end_date, :user_input_start_date

  def initialize(url, option = {})
    @browser  = Watir::Browser.new
    @url      = url
    @item_url = 'http://item.taobao.com/item.htm?spm=a230r.1.14.1.PO9xTu&id=15512619980&ns=1&abbucket=15#detail'

    unless option.empty?
      @end_date              = Date.parse(option.fetch(:end_date)) if option.fetch(:end_date, nil)
      @user_input_start_date = Date.parse(option.fetch(:start_date)) if option.fetch(:start_date, nil)
    end

  end

  def start_parse
    puts 'Parsing .....'
    browser.goto url
    parse_search_result
    go_to_each_seller
  end

  def sellers_data
  end

  private

  def go_to_each_seller
    seller_links.each do |link|
      browser.goto link
      parse_seller
    end
  end

  # get price transaction amount
  def parse_seller
    sleep(5)
    doc          = Nokogiri::HTML(browser.html)
    seller_name  = doc.css('div.tb-shop-name').css('h3').text

    #history_record
    item_counter = doc.css('div.item-counter')
    item_counter = item_counter.css('span#J_SellCounter').text

    # accumulator of the history deal counter
    transaction  = doc.css('div.tb-tabbar')
    deal_counter = transaction.css('em.J_TDealCount').text
    puts "Seller Name #{seller_name}, Item Counter : #{item_counter}, 成交紀錄: #{deal_counter}"

    browser.a(:class => 'J_item_tab J_item_record tab-btn').click
    parse_records
  end

  def parse_records
    page = 1
    while browser.a(:class => 'J_TAjaxTrigger page-next').present?
      puts "===================== page #{page} ===================="
      browser.a(:class => 'J_TAjaxTrigger page-next').click
      doc = Nokogiri::HTML(browser.html)
      sleep(3)

      break_outside = false
      records       = doc.css('tr.tb-change')
      records.each do |record|
        price  = record.css('em.tb-rmb-num').text
        amount = record.css('td.tb-amount').text
        if record.css('a.tb-promo').empty?
          title = 'Normal Product '
        else
          title = record.css('a.tb-promo')[0]['title']
        end

        bought_date = record.css('td.tb-start').text
        bought_date = Date.parse(bought_date)
        if end_date && (bought_date == end_date || bought_date < end_date)
          break_outside = true
          break
        end

        if valid_date?(bought_date)
          # user dont wanna this record
        else
          puts "Price : #{price}, amount: #{amount} title: #{title}, start date: #{bought_date}"
        end
      end

      break if break_outside
      page += 1
    end
  end

  # set the links of the seller
  def parse_search_result
    sleep(5)
    doc           = Nokogiri::HTML(browser.html)
    sellers       = doc.css('li.item')
    @seller_links = sellers.each_with_object([]) { |seller, links_array| links_array << seller.css('a')[0]['href'] }
  end

  def valid_date?(bought_date)
    user_input_start_date && (bought_date > user_input_start_date)
  end
end
