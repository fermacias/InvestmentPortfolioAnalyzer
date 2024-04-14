require "uri"
require "net/http"
require "json"
require 'date'

# Reads JSON data from a file and parses it into a Ruby object.
#
# @param [String] file_name The name of the JSON file to read.
# @return [Object] A Ruby object representing the parsed JSON data, which can be a hash or a list.
def read_json(file_name)
  file_path = File.expand_path(file_name, __dir__)
  data = File.read(file_path)
  return JSON.parse(data)
end

# Checks if a string is a valid date in DD-MM-YYYY format.
#
# @param [String] date_str The string to check.
# @return [Boolean] true if the string is a valid date, false otherwise.
def is_a_valid_date(date_str)
    Date.strptime(date_str, '%d-%m-%Y')
    true
  rescue ArgumentError
    false
  end

# Requests the user to enter a date in DD-MM-YYYY format.
#
# @param [String] prompt The prompt message for the user.
# @return [String] The date entered by the user.
def request_valid_date(prompt)
    loop do
      puts "#{prompt}: "
      date_str = gets.chomp
      return date_str if is_a_valid_date(date_str)
      puts "Error: #{date_str} is not a valid date in DD-MM-YYYY format. Please try again."
    end
end

# Converts a date from DD-MM-YYYY format to YYYY-MM-DD format.
#
# @param [String] date_str The date in DD-MM-YYYY format.
# @return [String] The date converted to YYYY-MM-DD format.
def convert_date_format(date_str)
    date_obj = Date.strptime(date_str, '%d-%m-%Y')
    date_obj.strftime('%Y-%m-%d')
end

# Requests the user to enter a valid integer.
#
# @param [String] prompt The prompt message for the user.
# @return [Integer] The integer entered by the user.
def request_valid_integer(prompt)
    loop do
      print "#{prompt}: "
      input = gets.chomp
      if input =~ /^\d+$/
        return input.to_i
      else
        puts "Error: Please enter a valid integer."
      end
    end
  end
