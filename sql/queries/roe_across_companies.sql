SELECT
    cd.company_name,
    cosf.net_income / bsf.total_stockholders_equity AS return_on_equity
    -- It should be the average of total equity, although there's not enough data
FROM
    companies_dim cd
LEFT JOIN
    consolidated_operations_statements_fact cosf ON cd.company_id = cosf.company_id
LEFT JOIN
    balance_sheets_fact bsf ON cd.company_id = bsf.company_id
WHERE
    bsf.total_stockholders_equity > 0
    AND cosf.net_income / bsf.total_stockholders_equity BETWEEN -2 AND 2
ORDER BY
    return_on_equity DESC;
