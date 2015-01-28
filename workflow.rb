require_relative 'crawler'
require 'Date'
require_relative 'csv_writer'

class WorkFlow

  # get user input until get right format
  attr_accessor :key_word, :start_date, :end_date
  MAIN_WEBSITE_URL = 'http://www.taobao.com/'
  KEY_WORD = '微熱山丘'
  def start
    guide_msg
    get_user_input
    call(key_word, start_date, end_date, number_of_shop)
  end

  private

  def get_user_input
    city = gets
    puts city
  end

  def guide_msg
    puts 'please input follow format for example: '
    puts '關鍵字   起始日      終止日     商店數'
    puts '為熱山丘 2015-01-28 2015-01-22 20 '
  end

end