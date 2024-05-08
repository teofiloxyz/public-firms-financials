SELECT
    cd.company_name,
    cd.exchange,
    cd.market_cap,
    bsf.total_stockholders_equity
FROM
    companies_dim cd
LEFT JOIN
    balance_sheets_fact bsf ON bsf.company_id = cd.company_id
WHERE
    cd.market_cap > 1e5
    AND bsf.total_stockholders_equity > 1e5
ORDER BY
    cd.market_cap DESC;
