SELECT
    sd.sector_name,
    COUNT(cd.company_id) AS num_companies
FROM
    companies_dim cd
LEFT JOIN
    sectors_dim sd ON cd.sector_id = sd.sector_id
WHERE
    sd.sector_name IS NOT NULL
GROUP BY
    sd.sector_name
ORDER BY
    num_companies DESC;
