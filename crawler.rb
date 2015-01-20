require 'nokogiri'
require 'open-uri'
require 'watir-webdriver'
require 'Date'
require_relative 'record'
require_relative 'seller'
require 'headless'


# This Class is used to crawler the data in taobo by keyword
class Crawler

  WAITTING_TIME = 3
  attr_reader :url, :sellers_data
  attr_reader :item_url
  attr_reader :key_word, :browser, :end_date, :user_input_start_date, :seller_name, :records
  attr_accessor :records

  def initialize(url, option = {})
    @headless = Headless.new
    @headless.start
    @browser  = Watir::Browser.new
    @url      = url
    @item_url = 'http://item.taobao.com/item.htm?spm=a230r.1.14.1.PO9xTu&id=15512619980&ns=1&abbucket=15#detail'
    @sellers_data = []
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

  def close
    browser.close
    headless.destroy
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
    sleep(WAITTING_TIME)
    doc          = Nokogiri::HTML(browser.html)
    @seller_name = doc.css('div.tb-shop-name').css('h3').text
    @records = []

    # product_title = doc.css('h3.tb-main-title').text
    sell_counter = doc.css('div.item-counter')
    sell_counter = sell_counter.css('span#J_SellCounter').text

    # accumulator of the history deal counter
    transaction  = doc.css('div.tb-tabbar')
    deal_counter = transaction.css('em.J_TDealCount').text
    puts "Seller Name #{seller_name}, Seller Counter : #{sell_counter}, 賣出件數: #{deal_counter}"
    browser.a(:class => 'J_item_tab J_item_record tab-btn').click
    parse_records

    @sellers_data << Seller.new(seller_name, sell_counter, deal_counter, records)
  end

  def parse_records
    page = 1

    while browser.a(:class => 'J_TAjaxTrigger page-next').present?
      puts "===================== page #{page} ===================="
      browser.a(:class => 'J_TAjaxTrigger page-next').click
      doc = Nokogiri::HTML(browser.html)
      sleep(WAITTING_TIME)

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

        if invalid_date?(bought_date)
          # user dont wanna this record
        else
          puts "Price : #{price}, amount: #{amount} title: #{title}, start date: #{bought_date}"
          @records << Record.new(unit_price: price, amount: amount, buyer_name: @seller_name, title: title, date: bought_date )
        end
      end

      break if break_outside
      page += 1
    end
  end

  # set the links of the seller
  def parse_search_result
    sleep(WAITTING_TIME)
    doc           = Nokogiri::HTML(browser.html)
    sellers       = doc.css('li.item')
    @seller_links = sellers.each_with_object([]) { |seller, links_array| links_array << seller.css('a')[0]['href'] }
    @seller_links = @seller_links[0..9]
  end

  def invalid_date?(bought_date)
    user_input_start_date && (bought_date > user_input_start_date)
  end

  def seller_links
    @seller_links
  end

  def headless
    @headless
  end
end
