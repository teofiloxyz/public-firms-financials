WITH illiquid_industries AS (
    SELECT
        id.industry_id,
        AVG(bsf.current_assets / bsf.total_current_liabilities) AS current_ratio
    FROM
        balance_sheets_fact bsf
    INNER JOIN
        companies_dim cd ON cd.company_id = bsf.company_id
    INNER JOIN
        industries_dim id ON id.industry_id = cd.industry_id
    WHERE
        id.industry_name IS NOT NULL
        AND bsf.current_assets IS NOT NULL
        AND bsf.total_current_liabilities != 0
    GROUP BY
        id.industry_id
    HAVING
        AVG(bsf.current_assets / bsf.total_current_liabilities) < 0.75
)

SELECT
    cd.company_name,
    csf.net_cash_provided_by_operating_activities AS operating_cashflow
FROM
    illiquid_industries ii
LEFT JOIN
    companies_dim cd ON cd.industry_id = ii.industry_id
LEFT JOIN
    cashflow_statements_fact csf ON csf.company_id = cd.company_id
WHERE
    csf.net_cash_provided_by_operating_activities IS NOT NULL
ORDER BY
    operating_cashflow
LIMIT 10;
