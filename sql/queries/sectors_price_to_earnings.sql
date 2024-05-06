SELECT
    cd.company_name,
    sd.sector_name,
    cd.market_cap / cosf.net_income AS price_to_earnings
    -- It's usually calculated by dividing each by number of shares, yielding the same result
FROM
    companies_dim cd
LEFT JOIN
    sectors_dim sd ON cd.sector_id = sd.sector_id
LEFT JOIN
    consolidated_operations_statements_fact cosf ON cd.company_id = cosf.company_id
WHERE
    sd.sector_name IS NOT NULL
    AND cosf.net_income > 0
    AND cd.market_cap / cosf.net_income BETWEEN 0.00001 AND 10000
ORDER BY
    price_to_earnings DESC;
