require 'rspec'
require 'json'
require 'stringio'
require './app/utils.rb' 

describe 'read_json' do
  let(:test_json_file) { 'spec/dummy_data.json' }
  it 'reads a valid JSON file' do
    json_data = read_json(test_json_file)
    expect(json_data).to be_a(Array)
    expect(json_data.size).to eq(2)
    expect(json_data[0]['risky_norris']).to eq(10)
    expect(json_data[1]['very_conservative_streep']).to eq(80)
  end
end


describe 'is_a_valid_date' do
  it 'returns true for a valid date string' do
    valid_date_str = '01-01-2022'
    expect(is_a_valid_date(valid_date_str)).to be_truthy
  end

  it 'returns false for an invalid date string' do
    invalid_date_str = '31-02-2022'
    expect(is_a_valid_date(invalid_date_str)).to be_falsy
  end

  it 'returns false for a random string' do
    invalid_date_str = 'randomstring'
    expect(is_a_valid_date(invalid_date_str)).to be_falsy
  end
end


describe 'request_valid_date' do
  let(:valid_date_input) { StringIO.new("01-01-2022\n") } 
  let(:invalid_date_input) { StringIO.new("31-02-2022\n") }
  let(:request_msg) { "Enter the investment start date" }

  before do
    $stdin = valid_date_input
  end

  after do
    $stdin = STDIN
  end

  it 'prompts user for a valid date' do
    expect {request_valid_date(request_msg)}.to output(request_msg+": \n").to_stdout
  end

  it 'returns a valid date input' do
    expect(request_valid_date(request_msg)).to eq('01-01-2022')
  end
end

describe 'convert_date_format' do
  it 'converts date format correctly' do
    date_str = '01-02-2022'
    converted_date = convert_date_format(date_str)
    expect(converted_date).to eq('2022-02-01')
  end
end

describe 'request_valid_integer' do
  let(:valid_integer_input) { StringIO.new("123\n") }
  let(:invalid_integer_input) { StringIO.new("abc\n") }
  request_msg = "Enter the investment amount"

  before do
    $stdin = valid_integer_input
  end

  after do
    $stdin = STDIN
  end

  it 'prompts user for a valid integer' do
    expect {request_valid_integer(request_msg)}.to output(request_msg+": ").to_stdout
  end

  it 'returns a valid integer input' do
    expect(request_valid_integer(request_msg)).to eq(123)
  end
end
