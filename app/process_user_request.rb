require "./utils.rb"
require "./controlers/client.rb"

# Gets the initial quota price from a hash containing fund information.
#
# @param [Hash] fund_data A hash with keys "initial_price" and "final_price".
# @return [Float] The initial quota price as an integer.
def get_initial_price_of_fund(fund_data)
    return fund_data["initial_price"]
end

# Gets the final quota price from a hash containing fund information.
#
# @param [Hash] fund_data A hash with keys "initial_price" and "final_price".
# @return [Float] The final quota price as an integer.
def get_final_price_of_fund(fund_data)
    return fund_data["final_price"]
end

# Gets the quota value for each available fund on a start date and an end date.
#
# @param [String] start_date The start date in DD-MM-YYYY format.
# @param [String] end_date The end date in ç format.
# @return [Hash] A hash containing each available fund and their respective quota values on the specified dates.
def get_funds_quota_prices(start_date, end_date)
    funds_ids = read_json("resources/constants.json")["funds_ids"]
    portafolio_quota_prices = {}
    formated_start_date = convert_date_format(start_date)
    formated_end_date = convert_date_format(end_date)
    funds_ids.each do |fund, id|
        portafolio_quota_prices[fund] = get_fund_quota_prices(
            id, formated_start_date, formated_end_date
        )
    end
    return portafolio_quota_prices
end

# Calculates the gains received for a portfolio.
#
# @param [Hash] portfolio A hash representing the investment portfolio with funds and investment percentages.
# @param [Hash] quota_prices_per_fund A hash containing initial and final quota prices for each fund available in the portfolio.
# @param [Integer] investment_amount The initial investment amount.
# @return [Float] The total returns calculated for the investment portfolio.
def calculate_portfolio_profit(
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
  return final_returns - investment_amount
end

#  Calculates the maximum profit among portfolios.
#
# @param [Hash] portfolio A hash representing the investment portfolio with funds and investment percentages.
# @param [Hash] quota_prices_per_fund A hash containing initial and final quota prices for each fund available in the portfolio.
# @param [Integer] investment_amount The initial investment amount.
# @return [Array] An array containing the maximum profit and the best portfolio.
def get_max_profit(portfolios, quota_prices_per_fund, investment_amount)
    max_returns = 0
    best_portfolio = portfolios[0]
    portfolios.each do |portfolio|
        current_returns = calculate_portfolio_profit(
            portfolio, quota_prices_per_fund, investment_amount
        )
        if current_returns > max_returns
            max_returns = current_returns
            best_portfolio = portfolio
        end
    end
    return max_returns, best_portfolio
end

# Processes the user's investment request and determines which portfolio provides the highest return within a specific time period.
#
# @param [String] start_date The start date of the period in DD-MM-YYYY format.
# @param [String] end_date The end date of the period in DD-MM-YYYY format.
# @param [Integer] investment_amount The amount invested in the investment.
# @return [void] This function does not return any value, but prints the result.
def process_user_request(start_date, end_date, investment_amount)
    portfolios = read_json("resources/portfolios.json")
    quota_prices_per_fund = get_funds_quota_prices(start_date, end_date)
    max_returns, best_portfolio = get_max_profit(portfolios, quota_prices_per_fund, investment_amount)
    puts "The best portfolio is #{best_portfolio} with profit #{max_returns}"
end
