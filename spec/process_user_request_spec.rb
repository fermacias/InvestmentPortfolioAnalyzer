require 'rspec'
require './app/process_user_request.rb'

describe 'get_initial_price_of_fund' do
    let(:fund_data) { { "initial_price" => 100 } }
  
    it 'returns the initial price of the fund' do
      expect(get_initial_price_of_fund(fund_data)).to eq(100)
    end
  end

describe 'get_final_price_of_fund' do
    let(:fund_data) { { "final_price" => 150 } }
  
    it 'returns the final price of the fund' do
      expect(get_final_price_of_fund(fund_data)).to eq(150)
    end
  end

describe 'get_funds_quota_prices' do
    before do
        mock_json_data = {"funds_ids" => {"fund_1" => 1, "fund_2" => 2}}
        allow_any_instance_of(Object).to receive(:read_json).and_return(mock_json_data)
        allow_any_instance_of(Object).to receive(:convert_date_format).and_return("2020-02-01")
        allow_any_instance_of(Object).to receive(:get_fund_quota_prices).and_wrap_original do |method, id, *args|
            {"initial_price"=> id, "final_price"=> id*2}
        end
    end

    it 'returns the correct quota prices for funds' do
        start_date = '01-01-2022'
        end_date = '31-01-2022'
        expected_result = {
            "fund_1" => {"initial_price"=> 1, "final_price"=> 2},
            "fund_2" => {"initial_price"=> 2, "final_price"=> 4}
        }
        expect(get_funds_quota_prices(start_date, end_date)).to eq(expected_result)
    end
end

describe 'calculate_portfolio_profit' do
    let(:portfolio) { { "fund_1" => 0.5, "fund_2" => 0.5 } }
    let(:quota_prices_per_fund) {
        { 
            "fund_1" => { "initial_price" => 100, "final_price" => 150 },
            "fund_2" => { "initial_price" => 200, "final_price" => 250 }
        }
    }
    let(:investment_amount) { 10000 }
  
    before do
      allow_any_instance_of(Object).to receive(:get_initial_price_of_fund).and_wrap_original do |method, *args|
        args[0]["initial_price"]
      end
  
      allow_any_instance_of(Object).to receive(:get_final_price_of_fund).and_wrap_original do |method, *args|
        args[0]["final_price"]
      end
    end
  
    it 'calculates portfolio profit correctly' do
        expected_profit = 3750
      expect(calculate_portfolio_profit(portfolio, quota_prices_per_fund, investment_amount)).to eq(expected_profit)
    end
  end

describe 'get_max_profit' do
    let(:portfolio_1) { { "fund_1" => 0.5, "fund_2" => 0.5 } }
    let(:portfolio_2) { { "fund_1" => 0.3, "fund_2" => 0.7 } }
    let(:portfolio_3) { { "fund_1" => 0.4, "fund_2" => 0.6 } }
    let(:portfolios) { [portfolio_1, portfolio_2] }
    let(:quota_prices_per_fund) { { "fund_1" => { "initial_price" => 100, "final_price" => 150 }, "fund_2" => { "initial_price" => 200, "final_price" => 250 }} }
    let(:investment_amount) { 10000 }
  
    before do
      allow_any_instance_of(Object).to receive(:calculate_portfolio_profit) do |instance, portfolio, _, _|
        case portfolio
        when portfolio_1
            3000
        when portfolio_2
            4000
        when portfolio_2
            2000
        end
      end
    end
  
    it 'returns the max profit and best portfolio' do
      max_profit, best_portfolio = get_max_profit(portfolios, quota_prices_per_fund, investment_amount)
      expect(max_profit).to eq(4000)
      expect(best_portfolio).to eq(portfolio_2)
    end
  end
  
describe 'process_user_request' do
    let(:start_date) { '01-01-2022' }
    let(:end_date) { '31-01-2022' }
    let(:investment_amount) { 10000 }
    let(:mock_portfolios) { { "portfolio_1" => { "fund_1" => 0.5, "fund_2" => 0.5 } } }
    let(:mock_quota_prices_per_fund) { { "fund_1" => { "initial_price" => 100, "final_price" => 150 }, "fund_2" => { "initial_price" => 200, "final_price" => 250 } } }
  
    before do
      allow_any_instance_of(Object).to receive(:read_json).with("resources/portfolios.json").and_return(mock_portfolios)
      allow_any_instance_of(Object).to receive(:get_funds_quota_prices).with(start_date, end_date).and_return(mock_quota_prices_per_fund)
      allow_any_instance_of(Object).to receive(:get_max_profit).with(mock_portfolios, mock_quota_prices_per_fund, investment_amount).and_return([4000, "portfolio_1"])
    end
  
    it 'processes user request and prints the best portfolio with profit' do
      expect { process_user_request(start_date, end_date, investment_amount) }.to output("The best portfolio is portfolio_1 with profit 4000\n").to_stdout
    end
  end