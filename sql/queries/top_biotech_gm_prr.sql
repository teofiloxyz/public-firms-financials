WITH top_biotech_by_gross_margin AS (
    SELECT
        cd.company_name,
        cd.market_cap,
        cosf.research_and_development_expenses,
        CASE
            WHEN cosf.gross_profit IS NOT NULL THEN
                cosf.gross_profit / cosf.total_net_sales
            WHEN cosf.cost_goods_and_services_sold IS NOT NULL THEN
                (cosf.total_net_sales - cosf.cost_goods_and_services_sold) / cosf.total_net_sales
            ELSE
                0
        END AS gross_margin
    FROM
        companies_dim cd
    LEFT JOIN
        consolidated_operations_statements_fact cosf ON cd.company_id = cosf.company_id
    LEFT JOIN
        industries_dim id ON cd.industry_id = id.industry_id
    WHERE
        id.industry_name LIKE '%Biotechnology%'
        AND cosf.total_net_sales > 0
        AND cd.market_cap > 0
        AND cosf.research_and_development_expenses > 0
    ORDER BY
        gross_margin DESC
    LIMIT 10
)

SELECT
    company_name,
    market_cap / research_and_development_expenses AS price_to_research
FROM
    top_biotech_by_gross_margin
ORDER BY
    price_to_research;
