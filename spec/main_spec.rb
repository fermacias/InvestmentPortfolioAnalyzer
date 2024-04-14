require 'rspec'
require './app/main.rb'

describe 'get_input_from_user' do
    let(:mock_start_date) { '2022-01-01' }
    let(:mock_investment_amount) { 10000 }
    let(:mock_good_end_date) { '2022-01-31' }
    let(:mock_bad_end_date) { '2021-01-31' }

    context 'the dates are in the correct order' do
        before do
            allow_any_instance_of(Object).to receive(:request_valid_date).with(any_args, "Enter the investment end date").and_return(mock_good_end_date)
            allow_any_instance_of(Object).to receive(:request_valid_date).with(any_args, "Enter the investment start date").and_return(mock_start_date)
            allow_any_instance_of(Object).to receive(:request_valid_integer).and_return(mock_investment_amount)
        end

        it 'returns valid input from the user' do
            expected_start_date = mock_start_date
            expected_end_date = mock_good_end_date
            expected_investment_amount = mock_investment_amount

            actual_start_date, actual_end_date, actual_investment_amount = get_input_from_user

            expect(actual_start_date).to eq(expected_start_date)
            expect(actual_end_date).to eq(expected_end_date)
            expect(actual_investment_amount).to eq(expected_investment_amount)
        end
    end

    context 'the dates are not in the correct order' do
        before do
            allow_any_instance_of(Object).to receive(:request_valid_date).with(any_args, "Enter the investment end date").and_return(mock_bad_end_date, mock_good_end_date)
            allow_any_instance_of(Object).to receive(:request_valid_date).with(any_args, "Enter the investment start date").and_return(mock_start_date)
            allow_any_instance_of(Object).to receive(:request_valid_integer).and_return(mock_investment_amount)
        end
        
        it 'displays error message' do
            expect { get_input_from_user }.to output("The end date must be after the start date.\n").to_stdout
        end
    end
end
