SELECT
    sd.sector_name,
    SUM(cd.market_cap) AS market_cap
FROM
    companies_dim cd
LEFT JOIN
    sectors_dim sd ON cd.sector_id = sd.sector_id
WHERE
    sd.sector_name IS NOT NULL
    AND cd.market_cap > 0
GROUP BY
    sd.sector_name
ORDER BY
    market_cap DESC;
