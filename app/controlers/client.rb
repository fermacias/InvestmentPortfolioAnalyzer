require "uri"
require "net/http"
require "json"
require 'date'

FINTUAL_REAL_ASSETS_BASE_URL = "https://fintual.cl/api/real_assets"

# Generates the Fintual API URL for retrieving real assets data.
#
# @param id [String] The ID of the fund.
# @param start_date [String] The start date of the data retrieval period in "yyyy-mm-dd" format.
# @param end_date [String] The end date of the data retrieval period in "yyyy-mm-dd" format.
# @return [String] The complete API URL.
def generate_real_assets_api_url(id, start_date, end_date)
  "#{FINTUAL_REAL_ASSETS_BASE_URL}/#{id}/days?from_date=#{start_date}&to_date=#{end_date}"
end

# Extracts the quota price at a specific date from the information extracted from the Fintual API for a given time period.
#
# @param [Hash] real_assets The information extracted from the API.
# @param [Integer] index The index of the date to be analyzed.
# @return [Float] The quota price.
def get_price_from_real_assets(real_assets, index)
    return real_assets['data'][index]['attributes']['price']
end

# Queries the Fintual API for information about a fund between a start date and an end date,
# aiming to extract the quota price on those dates.
# 
# @param [Integer] id The fund identifier.
# @param [String] start_date The start date in YYYY/MM/DD format.
# @param [String] end_date The end date in YYYY/MM/DD format.
# @return [Hash] A hash containing the information for the initial and final quota prices.
def get_fund_quota_prices(id, start_date, end_date)
    url = generate_real_assets_api_url(id, start_date, end_date)
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
