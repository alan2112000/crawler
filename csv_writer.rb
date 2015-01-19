require 'csv'
class CsvWriter

  def self.call(sellers_data)

    CSV.open('testFile.csv', 'w') do |csv|
      csv << ['first_column', 'second_column', 'thrid_column']

      date_string = %w[2015-01-18 2015-01-17 2015-01-16 2015-01-15 2015-01-14 2015-01-13 2015-01-12 2015-01-11]
      date_string.each do |date|
        date = Date.parse(date)
        sellers_data.each do |seller|
          daily_amount = seller.daily_amount(date)
          average_price = seller.average_price
          csv << [seller.name, daily_amount, average_price]
        end
      end
    end
  end
end