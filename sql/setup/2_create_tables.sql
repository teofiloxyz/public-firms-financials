-- Sectors dimension table
CREATE TABLE sectors_dim (
    sector_id SERIAL PRIMARY KEY,
    sector_name TEXT
);

-- Industries dimension table
CREATE TABLE industries_dim (
    industry_id SERIAL PRIMARY KEY,
    industry_name TEXT
);

-- Countries dimension table
CREATE TABLE countries_dim (
    country_id SERIAL PRIMARY KEY,
    country_name TEXT
);

-- Companies dimension table
CREATE TABLE companies_dim (
    company_id SERIAL PRIMARY KEY,
    company_name TEXT,
    ticker TEXT,
    CIK INTEGER,
    sector_id INTEGER,
    industry_id INTEGER,
    country_id INTEGER,
    exchange TEXT,
    market_cap REAL,
    IPO_year INTEGER,
    FOREIGN KEY (sector_id) REFERENCES sectors_dim (sector_id),
    FOREIGN KEY (industry_id) REFERENCES industries_dim (industry_id),
    FOREIGN KEY (country_id) REFERENCES countries_dim (country_id)
);

-- Balance sheet statements fact table
CREATE TABLE balance_sheets_fact (
    company_id INTEGER,
    statement_date DATE,
    cash_and_cash_equivalents REAL,
    short_term_investments REAL,
    other_current_assets REAL,
    current_assets REAL,
    marketable_securities REAL,
    property_and_plant_and_equipment REAL,
    other_non_current_assets REAL,
    total_non_current_assets REAL,
    total_assets REAL,
    accounts_payable REAL,
    other_current_liabilities REAL,
    deferred_revenue REAL,
    commercial_paper REAL,
    term_debt REAL,
    accrued_liabilities REAL,
    total_current_liabilities REAL,
    non_current_long_term_debt REAL,
    other_non_current_liabilities REAL,
    total_non_current_liabilities REAL,
    total_liabilities REAL,
    retained_earnings REAL,
    accumulated_other_comprehensive_income REAL,
    total_stockholders_equity REAL,
    total_liabilities_and_stockholders_equity REAL,
    common_stock REAL,
    common_stock_and_paid_in_capital REAL,
    FOREIGN KEY (company_id) REFERENCES companies_dim (company_id)
);

-- Consolidated statements of operations fact table
CREATE TABLE consolidated_operations_statements_fact (
    company_id INTEGER,
    statement_date DATE,
    total_net_sales REAL,
    cost_of_revenue REAL,
    gross_profit REAL,
    marketing_expense REAL,
    research_and_development_expenses REAL,
    general_and_administrative_expenses REAL,
    total_operating_expenses REAL,
    operating_income REAL,
    interest_expense REAL,
    non_operating_income REAL,
    income_before_taxes REAL,
    income_tax_expense REAL,
    net_income REAL,
    basic REAL,
    diluted REAL,
    basic_1 REAL,
    diluted_1 REAL,
    revenue REAL,
    selling_general_and_administrative_expenses REAL,
    cost_goods_and_services_sold REAL,
    FOREIGN KEY (company_id) REFERENCES companies_dim (company_id)
);

-- Cashflow statements fact table
CREATE TABLE cashflow_statements_fact (
    company_id INTEGER,
    statement_date DATE,
    net_income REAL,
    depreciation_and_amortization REAL,
    stock_based_compensation REAL,
    foreign_currency_transaction_gain_or_loss REAL,
    other_noncash_income_or_expense REAL,
    changes_in_other_current_assets REAL,
    changes_in_accounts_payable REAL,
    changes_in_inventories REAL,
    changes_in_deferred_revenue REAL,
    net_cash_provided_by_operating_activities REAL,
    purchases_of_marketable_securities REAL,
    proceeds_from_maturities_of_marketable_securities REAL,
    proceeds_from_sale_of_marketable_securities REAL,
    purchases_of_property_and_plant_and_equipment REAL,
    payments_to_acquire_investments REAL,
    payments_to_acquire_businesses REAL,
    deferred_revenue REAL,
    other_investing_activities REAL,
    net_cash_provided_by_investing_activities REAL,
    payments_of_tax_for_share_based_compensation REAL,
    dividends_paid REAL,
    repurchases_of_common_stock REAL,
    proceeds_from_issuance_of_common_stock REAL,
    repayments_of_long_term_debt REAL,
    net_cash_provided_by_financing_activities REAL,
    changes_in_cash_and_cash_equivalents_and_restricted_cash REAL,
    cash_and_cash_equivalents_and_restricted_cash REAL,
    FOREIGN KEY (company_id) REFERENCES companies_dim (company_id)
);
