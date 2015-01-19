require 'nokogiri'
require_relative 'record'
class TaoBaoParser

  attr_accessor :doc

  def seller_name
    doc.css
  end

  def item_counter

  end

  def deal_counter

  end

  def price

  end

  def amount

  end

  def bought_date

  end

  def records
    records = doc.css('tr.tb-change')

    records.each do |recordd|

    end
  end

  def special_product?

  end

  def special_product_name

  end


end