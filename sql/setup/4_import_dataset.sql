/*
Import the dataset from the CSV files into the respective database tables
It only worked with \copy instead of COPY
*/

-- Sectors dimension table
\copy sectors_dim FROM 'data/sectors_dim.csv' DELIMITER ',' CSV HEADER;

-- Industries dimension table
\copy industries_dim FROM 'data/industries_dim.csv' DELIMITER ',' CSV HEADER;

-- Countries dimension table
\copy countries_dim FROM 'data/countries_dim.csv' DELIMITER ',' CSV HEADER;

-- Companies dimension table
\copy companies_dim FROM 'data/companies_dim.csv' DELIMITER ',' CSV HEADER;

-- Balance sheet statements fact table
\copy balance_sheets_fact FROM 'data/balance_sheets_fact.csv' DELIMITER ',' CSV HEADER;

-- Consolidated statements of operations fact table
\copy consolidated_operations_statements_fact FROM 'data/consolidated_operations_statements_fact.csv' DELIMITER ',' CSV HEADER;

-- Cashflow statements fact table
\copy cashflow_statements_fact FROM 'data/cashflow_statements_fact.csv' DELIMITER ',' CSV HEADER;
