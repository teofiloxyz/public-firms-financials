# Dataset Source
- All of the data was collected on April 27th.
- Company information was retrieved from the [NASDAQ website](https://www.nasdaq.com/market-activity/stocks/screener).
- The financial statements were extracted from the SEC filings, with the valuable help of [Edgartools](https://github.com/dgunning/edgartools). This Python library was modified slightly to fetch the financial data from a list of companies, saving it into CSV files. This way it was able to gather the financial information from 4,317 companies, listed on both the NYSE and NASDAQ exchanges.
- After that, the data was compiled and organized into the CSV files located in this folder, using Python (Pandas).
- Finally, the dataset was imported into a PostgreSQL database (for more details, check the [database setup scripts](/sql/setup/)).
