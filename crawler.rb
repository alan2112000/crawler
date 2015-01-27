require 'nokogiri'
require 'open-uri'
require 'watir-webdriver'
require 'Date'
require_relative 'record'
require_relative 'seller'
require 'headless'
require_relative 'taobao_parser'


# This Class is used to crawler the data in taobo by keyword
class Crawler

  FIFTEEN_SIZE_PRODUCT = 15
  TEN_SIZE_PRODUCT     = 10
  WAITTING_TIME        = 3
  attr_reader :url, :sellers_data
  attr_reader :key_word, :browser, :end_date, :user_input_start_date, :seller_name, :records, :number_of_received_people
  attr_accessor :records

  def initialize(url, key_word, option = {})
    @browser      = Watir::Browser.new
    @url          = url
    @sellers_data = []
    @key_word     = key_word
    unless option.empty?
      @end_date              = Date.parse(option.fetch(:end_date)) if option.fetch(:end_date, nil)
      @user_input_start_date = Date.parse(option.fetch(:start_date)) if option.fetch(:start_date, nil)
    end

  end

  def start_parse
    puts 'Parsing .....'
    browser.goto url
    sleep(WAITTING_TIME)
    browser.a(:class => 'J_btn_toCN').click
    type_key_word(key_word)
    parse_search_result
    go_to_each_seller
  end

  def close
    browser.close
  end

  def type_key_word(key_word)
    sleep(WAITTING_TIME)
    browser.text_field(:id, 'q').set(key_word)
    browser.button(:class, 'btn-search').click

  end

  private

  def go_to_each_seller
    seller_links.each_with_index do |link, index|
      browser.goto link
      parse_seller
      sellers_data.last.number_of_received_people = number_of_received_people[index]
    end
  end

  # get price transaction amount
  def parse_seller
    sleep(WAITTING_TIME)
    @seller_name = TaoBaoParser.seller_name(browser.html)
    @records     = []

    product_title        = TaoBaoParser.product_title(browser.html)
    size                 = get_product_size(product_title)
    success_sold_counter = TaoBaoParser.item_counter(browser.html)
    deal_counter         = TaoBaoParser.deal_counter(browser.html)
    puts "Seller Name #{seller_name}, 成功賣出 : #{success_sold_counter}, 賣出件數: #{deal_counter}, Product Size #{size}, 產品名 :#{product_title}"
    parse_records(size)

    @sellers_data << Seller.new(seller_name, success_sold_counter, deal_counter, records, product_title: product_title)
  end

  def parse_records(product_size)
    page = 1

    browser.li(:class => 'tb-last').a(:class => 'tb-tab-anchor').click
    sleep(WAITTING_TIME)
    # while browser.a(:class => 'J_TAjaxTrigger page-next').present?
    while true
      puts "===================== page #{page} ===================="
      sleep(WAITTING_TIME)

      break_outside = false
      records       = TaoBaoParser.records(browser.html)
      records.each do |record|
        price       = TaoBaoParser.price(record)
        amount      = TaoBaoParser.amount(record)
        title       = TaoBaoParser.title(record)
        bought_date = TaoBaoParser.bought_date(record)

        if bought_date
          if end_date && (bought_date < end_date)
            break_outside = true
            break
          end

          if invalid_date?(bought_date)
            puts 'error occur or already touch the end date'
          else
            puts "Price : #{price}, amount: #{amount} title: #{title}, start date: #{bought_date}, Size: #{product_size}"
            @records << Record.new(unit_price: price, amount: amount, buyer_name: @seller_name, title: title, date: bought_date, size: product_size)
            @records.select! { |record| end_date < record.date }
          end
        end
      end

      break if break_outside
      page += 1
      browser.a(:class => 'J_TAjaxTrigger page-next').click
    end
  end

  # set the links of the seller
  def parse_search_result
    sleep(WAITTING_TIME)
    sortby_amount_of_sold

    sellers                    = TaoBaoParser.sellers_link(browser.html)
    @seller_links              = sellers.each_with_object([]) { |seller, links_array| links_array << seller.css('a')[0]['href'] }
    @number_of_received_people = sellers.each_with_object([]) { |seller, deals_people_array| deals_people_array << TaoBaoParser.transaction_people_counter(seller) }
    @seller_links              = @seller_links[0..15]

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

  def sortby_amount_of_sold
    browser.lis(class: 'sort')[2].a.click
    sleep(WAITTING_TIME)
  end

  def get_product_size(product_name)
    if product_name.match(TEN_SIZE_PRODUCT.to_s)
      TEN_SIZE_PRODUCT
    elsif product_name.match(FIFTEEN_SIZE_PRODUCT.to_s)
      FIFTEEN_SIZE_PRODUCT
    end
  end

end
