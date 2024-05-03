SELECT
    cd.company_name,
    cd.exchange,
    cd.market_cap,
    bsf.total_stockholders_equity
FROM
    companies_dim cd
LEFT JOIN
    balance_sheets_fact bsf ON cd.company_id = bsf.company_id
WHERE
    cd.market_cap IS NOT NULL
    AND bsf.total_stockholders_equity IS NOT NULL
ORDER BY
    cd.market_cap DESC;
