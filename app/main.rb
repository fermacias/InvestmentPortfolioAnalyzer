require_relative "utils.rb"
require_relative "process_user_request.rb"
require 'date'

# Gets input from the user for investment parameters.
#
# @return [Array] An array containing the start date, end date, and investment amount.
def get_input_from_user
    start_date = nil
    end_date = nil
    loop do
        start_date = request_valid_date("Enter the investment start date")
        end_date = request_valid_date("Enter the investment end date")
        break if Date.parse(start_date) < Date.parse(end_date)
        puts "The end date must be after the start date."
    end
    investment_amount = request_valid_integer("Enter the investment amount")
    return start_date, end_date, investment_amount
end

if __FILE__ == $0
    start_date, end_date, investment_amount = get_input_from_user()
    process_user_request(start_date, end_date, investment_amount)
  end
