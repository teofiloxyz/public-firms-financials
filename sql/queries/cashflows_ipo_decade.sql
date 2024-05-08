WITH ipo_decade_ranges AS (
    SELECT 
        GENERATE_SERIES(1920, 2020, 10) AS decade_start,
        GENERATE_SERIES(1929, 2029, 10) AS decade_end
)

SELECT 
    CONCAT(decade_start, 's') AS ipo_decade,
    AVG(COALESCE(csf.net_cash_provided_by_operating_activities,0)) AS operating_cashflow,
    AVG(COALESCE(csf.net_cash_provided_by_investing_activities,0)) AS investing_cashflow,
    AVG(COALESCE(csf.net_cash_provided_by_financing_activities,0)) AS financing_cashflow,
    AVG(COALESCE(csf.net_cash_provided_by_operating_activities,0)) +
    AVG(COALESCE(csf.net_cash_provided_by_investing_activities,0)) +
    AVG(COALESCE(csf.net_cash_provided_by_financing_activities,0)) AS net_cash
FROM 
    companies_dim cd
RIGHT JOIN 
    ipo_decade_ranges ON cd.ipo_year BETWEEN decade_start AND decade_end
LEFT JOIN
    cashflow_statements_fact csf ON csf.company_id = cd.company_id
WHERE
    cd.ipo_year IS NOT NULL
GROUP BY 
    ipo_decade
HAVING
    COUNT(cd.company_id) > 5
ORDER BY 
    ipo_decade;
