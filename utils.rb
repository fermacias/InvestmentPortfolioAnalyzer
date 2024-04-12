require "uri"
require "net/http"
require "json"

# Reads JSON data from a file and parses it into a Ruby object.
#
# @param [String] file_name The name of the JSON file to read.
# @return [Object] A Ruby object representing the parsed JSON data, which can be a hash or a list.
def readJson(file_name)
    json_data = File.read(file_name)
    return JSON.parse(json_data)
end

# Extracts the quota price at a specific date from the information extracted from the Fintual API for a given time period.
#
# @param [Array<Hash>] real_assets The information extracted from the API, represented as a list containing hashes corresponding to each date.
# @param [Integer] index The index of the date to be analyzed.
# @return [Float] The quota price at the specified date.
def get_price_from_real_assets(real_assets, index)
    return real_assets['data'][index]['attributes']['price']
end

# Queries the Fintual API for information about a fund between a start date and an end date, aiming to extract the quota price on those dates.
#
# @param [Integer] id The fund identifier.
# @param [String] start_date The start date in YYYY/MM/DD format.
# @param [String] end_date The end date in YYYY/MM/DD format.
# @return [Hash] A hash containing the information for the initial and final quota prices.
def get_fund_quota_prices(id, start_date, end_date)
    url = "https://fintual.cl/api/real_assets/#{id}/days?from_date=#{start_date}&to_date=#{end_date}"
    uri = URI(url)
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      result = JSON.parse(res.body)
      initial_price = get_price_from_real_assets(result, 0)
      final_price = get_price_from_real_assets(result, -1)
      return {
        "initial_price"=> initial_price,
        "final_price"=> final_price
      }
    else
        raise StandardError, "Error: API did not respond successfully"
    end
end

# Gets the initial quota price from a hash containing fund information.
#
# @param [Hash] fund_data A hash with keys "initial_price" and "final_price" representing the initial and final quota prices.
# @return [Float] The final quota price as an integer.
def get_initial_price_of_fund(fund_data)
    return fund_data["initial_price"]
end

# Gets the final quota price from a hash containing fund information.
#
# @param [Hash] fund_data A hash with keys "initial_price" and "final_price" representing the initial and final quota prices.
# @return [Float] The final quota price as an integer.
def get_final_price_of_fund(fund_data)
    return fund_data["final_price"]
end

# Calculates the quota value for each available fund on a start date and an end date.
#
# @param [String] start_date The start date in YYYY/MM/DD format.
# @param [String] end_date The end date in YYYY/MM/DD format.
# @return [Hash] A hash containing each available fund and their respective quota values on the specified dates.
# todo: change to DD-MM-YYYY
def get_funds_quota_prices(start_date, end_date)
    funds_ids = readJson("constants.json")["funds_ids"]
    portafolio_quota_prices = {}
    funds_ids.each do |fund, id|
        portafolio_quota_prices[fund] = get_fund_quota_prices(
            id, start_date, end_date
        )
    end
    return portafolio_quota_prices
end