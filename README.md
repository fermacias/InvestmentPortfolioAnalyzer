# InvestmentPortfolioAnalyzer
This program utilizes the Fintual API to calculate the potential returns of different investment portfolios. It reads from a portfolios.json file containing 10 different investment portfolios, each using the 4 Fintual investment funds. The program takes inputs such as the investment start date, withdrawal date, and initial investment amount to determine the maximum potential gain using the most suitable portfolio.

## Usage
Ensure you have a portfolios.json file in the root directory with the required portfolio data. The portfolio must have the following format.

[
  {
    "risky_norris": 0.6,
    "moderate_pitt": 0.2,
    "conservative_clooney": 0.1,
    "very_conservative_streep": 0.1
  },
  {
    "risky_norris": 0.1,
    "moderate_pitt": 0.2,
    "conservative_clooney": 0.3,
    "very_conservative_streep": 0.4
  },
  ...
]
