-- Create indexes for performance optimization

-- Companies dimension table
CREATE INDEX idx_companies_sector_id ON companies_dim (sector_id);
CREATE INDEX idx_companies_industry_id ON companies_dim (industry_id);
CREATE INDEX idx_companies_country_id ON companies_dim (country_id);

-- Balance sheet statements fact table
CREATE INDEX idx_balance_sheets_fact_company_id ON balance_sheets_fact (company_id);

-- Consolidated statements of operations fact table
CREATE INDEX idx_consolidated_operations_statements_fact_company_id ON consolidated_operations_statements_fact (company_id);

-- Cashflow statements fact table
CREATE INDEX idx_cashflow_statements_fact_company_id ON cashflow_statements_fact (company_id);
