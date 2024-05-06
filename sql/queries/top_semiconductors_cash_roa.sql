SELECT
    cd.company_name,
    csf.net_cash_provided_by_operating_activities / bsf.total_assets AS cash_return_on_assets
FROM
    companies_dim cd
LEFT JOIN
    cashflow_statements_fact csf ON cd.company_id = csf.company_id
LEFT JOIN
    balance_sheets_fact bsf ON cd.company_id = bsf.company_id
LEFT JOIN
    industries_dim id ON cd.industry_id = id.industry_id
WHERE
    id.industry_name = 'Semiconductors'
    AND csf.net_cash_provided_by_operating_activities IS NOT NULL
    AND bsf.total_assets IS NOT NULL
ORDER BY
    cash_return_on_assets DESC
LIMIT 10;
