SELECT
    cd.company_name,
    cosf.net_income / bsf.total_assets AS return_on_assets,
    -- It should be the average total_assets
    bsf.total_stockholders_equity
FROM
    companies_dim cd
LEFT JOIN
    consolidated_operations_statements_fact cosf ON cd.company_id = cosf.company_id
LEFT JOIN
    balance_sheets_fact bsf ON cd.company_id = bsf.company_id
WHERE
    bsf.total_stockholders_equity > 1e+06
    AND cosf.net_income / bsf.total_assets BETWEEN -2 AND 0.5
ORDER BY
    bsf.total_stockholders_equity DESC;
