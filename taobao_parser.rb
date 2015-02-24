require 'nokogiri'
require_relative 'record'
require 'Date'
class TaoBaoParser

  attr_accessor :doc

  def self.seller_name(html)
    doc = Nokogiri::HTML(html)
    doc.css('div.tb-shop-name').css('a').text
  end

  def self.sellers_link(html)
    doc = Nokogiri::HTML(html)
    doc.css('div.item')
  end

  # 30天賣出商品數量
  def self.item_counter(html)
    doc  = Nokogiri::HTML(html)
    item = doc.css('div.tb-sell-counter')
    item.css('strong#J_SellCounter').text.to_i
  end

  # 30天交易次數
  def self.deal_counter(html)
    doc         = Nokogiri::HTML(html)
    transaction = doc.css('li.tb-last')
    transaction.css('em.J_TDealCount').text.to_i
  end

  # 商品名
  def self.product_title(html)
    doc = Nokogiri::HTML(html)
    doc.css('h3.tb-main-title').text
  end
  def self.price(record)
    record.css('em.tb-rmb-num').text.to_i
  end

  def self.amount(record)
    record.css('td.tb-amount').text.to_i
  end

  # 特別促銷
  def self.title(record)
    if record.css('a.tb-promo').empty?
      'Normal Product '
    else
      record.css('a.tb-promo')[0]['title']
    end
  end

  def self.bought_date(record)
    bought_date = record.css('td.tb-start').text
    if bought_date.empty?
      false
    else
      DateTime.parse(bought_date)
    end
  end

  def self.records(html)
    doc = Nokogiri::HTML(html)
    doc.css('table.tb-list').css('tbody').css('tr')
  end

  def self.transaction_people_counter(doc)
    doc.css('div.deal-cnt').text.to_i
  end

end