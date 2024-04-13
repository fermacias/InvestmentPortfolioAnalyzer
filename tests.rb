require 'minitest/autorun'
require './utils.rb'
require './main.rb'

class TestPortfolioCalculator < MiniTest::Test
  def test_portfolio_returns_calculator
    portfolio = {
        "risky_norris" => 0.6,
        "moderate_pitt" => 0.2,
        "conservative_clooney" => 0.1,
        "very_conservative_streep" => 0.1
    }
    quota_prices_per_fund = {
      "risky_norris" => { "initial_price" => 10, "final_price" => 12 },
      "moderate_pitt" => { "initial_price" => 20, "final_price" => 25 },
      "conservative_clooney" => { "initial_price" => 50, "final_price" => 55 },
      "very_conservative_streep" => { "initial_price" => 40, "final_price" => 45 },
    }
    investment_amount = 100
    expected_returns = 19.25

    actual_returns = portfolio_returns_calculator(portfolio, quota_prices_per_fund, investment_amount)
    puts actual_returns
    assert_equal expected_returns, actual_returns
  end
end
