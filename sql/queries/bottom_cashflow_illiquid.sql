-- Get industries with an average current ratio below 0.75 as a CTE
WITH most_illiquid_industries AS (
    SELECT
        id.industry_id,
        AVG(bsf.current_assets / bsf.total_current_liabilities) AS current_ratio
    FROM
        industries_dim id
    INNER JOIN
        companies_dim cd ON id.industry_id = cd.industry_id
    INNER JOIN
        balance_sheets_fact bsf ON cd.company_id = bsf.company_id
    WHERE
        id.industry_name IS NOT NULL
        AND bsf.current_assets > 0
        AND bsf.total_current_liabilities > 0
    GROUP BY
        id.industry_id
    HAVING
        AVG(bsf.current_assets / bsf.total_current_liabilities) < 0.75
)

-- Get the companies from those industries with the lowest operating cash flow
SELECT
    cd.company_name,
    csf.net_cash_provided_by_operating_activities AS operating_cashflow
FROM
    most_illiquid_industries mi
LEFT JOIN
    companies_dim cd ON mi.industry_id = cd.industry_id
LEFT JOIN
    cashflow_statements_fact csf ON cd.company_id = csf.company_id
WHERE
    csf.net_cash_provided_by_operating_activities IS NOT NULL
ORDER BY
    operating_cashflow
LIMIT 10;
