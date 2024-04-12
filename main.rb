require "./utils.rb"
require 'date'

# Analyzes the gains received for a portfolio.
#
# @param [Hash] portfolio A hash representing the investment portfolio with funds and investment percentages.
# @param [Hash] quota_prices_per_fund A hash containing initial and final quota prices for each fund available in the portfolio.
# @param [Integer] investment_amount The initial investment amount.
# @return [Float] The total returns calculated for the investment portfolio.
def portfolio_returns_calculator(
    portfolio, quota_prices_per_fund, investment_amount
)
    final_returns = 0
    portfolio.each do |fund, percentage|
        fund_data = quota_prices_per_fund[fund]
        initial_quota_price = get_initial_price_of_fund(fund_data)
        final_quota_price = get_final_price_of_fund(fund_data)
        quotas = investment_amount*percentage/initial_quota_price
        final_returns += (final_quota_price * quotas)
    end
  return final_returns
end

# Analyzes the available portfolios and determines which one provides the highest return within a specific time period.
#
# @param [String] start_date The start date of the period in DD-MM-YYYY format.
# @param [String] end_date The end date of the period in DD-MM-YYYY format.
# @param [Integer] investment_amount The amount invested in the investment.
# @return [void] This function does not return any value, but prints the result.
def portfolios_analyzer(start_date, end_date, investment_amount)
    portfolios = readJson("portfolios.json")
    quota_prices_per_fund = get_funds_quota_prices(start_date, end_date)
    
    max_returns = 0
    best_portfolio = portfolios[0]
    portfolios.each do |portfolio|
        current_returns = portfolio_returns_calculator(
            portfolio, quota_prices_per_fund, investment_amount
        )
        if current_returns > max_returns
            max_returns = current_returns
            best_portfolio = portfolio
        end
    end
    puts "El mejor portafolio es #{best_portfolio} con ganancia #{max_returns}"
end

if __FILE__ == $0
    start_date = nil
    end_date = nil
    loop do
        # start_date = "05-01-2020"
        start_date = get_valid_date("Enter the investment start date")
        # end_date = "20-01-2020"
        end_date = get_valid_date("Enter the investment end date")
        break if Date.parse(start_date) < Date.parse(end_date)
        puts "The end date must be after the start date."
    end
    investment_amount = 20000
    # investment_amount = get_valid_integer("Enter the investment amount")

    portfolios_analyzer(start_date, end_date, investment_amount)
  end
