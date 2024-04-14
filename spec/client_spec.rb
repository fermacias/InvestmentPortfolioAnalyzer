require 'rspec'
require './app/controlers/client.rb'

describe 'generate_real_assets_api_url' do
  let(:id) { 123 }
  let(:start_date) { '2022-01-01' }
  let(:end_date) { '2022-01-31' }
  let(:base_url) { 'https://fintual.cl/api/real_assets' }
  let(:expected_url) { base_url+"/#{id}/days?from_date=#{start_date}&to_date=#{end_date}" }

  it 'generates the correct API URL' do
    actual_url = generate_real_assets_api_url(id, start_date, end_date)
    expect(actual_url).to eq(expected_url)
  end
end

describe 'get_price_from_real_assets' do
    let(:real_assets) {{
        'data' => [
            { 'attributes' => { 'price' => 100 } },
            { 'attributes' => { 'price' => 150 } },
            { 'attributes' => { 'price' => 200 } }
        ]
    }}
  
    it 'returns the price of the specified index from real assets' do
      index = 1
      expected_price = 150
  
      actual_price = get_price_from_real_assets(real_assets, index)
      expect(actual_price).to eq(expected_price)
    end
  end


class MockHTTPResponse
    attr_reader :body
  
    def initialize(body)
      @body = body
    end
  
    def is_a?(klass)
      klass == Net::HTTPSuccess
    end
  end

class MockHTTPErrorResponse
    def is_a?(klass)
      klass == Net::HTTPInternalServerError
    end
end

describe 'get_fund_quota_prices' do
    let(:id) { 123 }
    let(:start_date) { '2022-01-01' }
    let(:end_date) { '2022-01-31' }
    let(:mock_real_assets_response) {{
        'data' => [
          { 'attributes' => { 'price' => 100 } },
          { 'attributes' => { 'price' => 150 } },
          { 'attributes' => { 'price' => 200 } }
        ]
    }}

    context 'when API response is successful' do
        before do
            allow(Net::HTTP).to receive(:get_response).and_return(MockHTTPResponse.new(mock_real_assets_response.to_json))
            allow(JSON).to receive(:parse).and_return(mock_real_assets_response)
            allow_any_instance_of(Object).to receive(:get_price_from_real_assets).with(any_args, 0).and_return(100)
            allow_any_instance_of(Object).to receive(:get_price_from_real_assets).with(any_args, -1).and_return(200)
        end
        it 'returns initial and final prices from fund quota prices' do
            expected_result = { "initial_price" => 100, "final_price" => 200 }
            actual_result = get_fund_quota_prices(id, start_date, end_date)
            expect(actual_result).to eq(expected_result)
        end
    end

    context 'when API response is not successful' do
        before do
            allow(Net::HTTP).to receive(:get_response).and_return(MockHTTPErrorResponse.new)
        end    
        it 'raises an error when API response is not successful' do
            expect { get_fund_quota_prices(id, start_date, end_date) }.to raise_error(StandardError, "Error: API did not respond successfully")
        end
      end
  end