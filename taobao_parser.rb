require 'nokogiri'
require_relative 'record'
require 'Date'
class TaoBaoParser

  attr_accessor :doc

  def self.seller_name(html)
    doc = Nokogiri::HTML(html)
    doc.css('div.tb-shop-name').css('h3').text
  end

  def self.sellers_link(html)
    doc = Nokogiri::HTML(html)
    doc.css('li.item')
  end

  # 30天賣出商品數量
  def self.item_counter(html)
    doc  = Nokogiri::HTML(html)
    item = doc.css('div.item-counter')
    item.css('span#J_SellCounter').text
  end

  # 30天交易次數
  def self.deal_counter(html)
    doc         = Nokogiri::HTML(html)
    transaction = doc.css('div.tb-tabbar')
    transaction.css('em.J_TDealCount').text
  end

  # 商品名
  def self.product_title(html)
    doc = Nokogiri::HTML(html)
    doc.css('h3.tb-main-title').text
  end
  def self.price(record)
    record.css('em.tb-rmb-num').text
  end

  def self.amount(record)
    record.css('td.tb-amount').text
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
    Date.parse(bought_date)
  end

  def self.records(html)
    doc = Nokogiri::HTML(html)
    doc.css('tr.tb-change')
  end

  def self.transaction_people_counter(doc)
    doc.css('span.paid-num').css('a').text
  end

end