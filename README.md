# Public Firms Financials 📈

## Introduction
**Public Firms Financials** is a financial data analysis showcase, using mostly PostgreSQL. This project delves into the financials of 4,317 companies listed on the NYSE and NASDAQ exchanges (For detailed information about the dataset, check the [data folder](/data/)).

## Tools Used
- **[Edgartools](https://github.com/dgunning/edgartools)** (To collect financial data from the SEC filings)
- **Pandas** (For compiling the dataset)
- **PostgreSQL** (For data manipulation & analysis and database management)
- **Matplotlib and Seaborn** (For creating charts)

## Analysis Overview
The project aims to provide comprehensive insights through a diverse combination of SQL queries, financial analysis and data visualization techniques. PostgreSQL takes the lead in data manipulation and analysis, while Python is exclusively employed for visualization purposes.

### How many companies are in each sector?
For this we need the sector names along with the count of their respective companies.

<details>
<summary>Click to reveal SQL query</summary>

```sql
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
```
</details>

Most of the companies are from the health care, finance and consumer discretionary sectors, compared to just a few from the basic materials sector.

![Sector companies number chart](/images/sector_companies_number.jpg)
*Bar chart of the number of companies by sector.*

<br> <!-- Line break -->

### What is the market capitalization of each sector?
We have to gather the sector names and the sum of the market cap of their respective companies.

<details>
    <summary>Click to reveal SQL query</summary>
    ```sql
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
    ```
</details>

When considering market capitalization, there's a notable shift. The technology sector emerges as the largest.

![Sector market cap weight chart](/images/sector_market_cap_weight.jpg)
*Bar chart of the market capitalization of each sector.*

<br> <!-- Line break -->

### What is the relationship between market cap and total equity?
For this, we need the companies, their market cap, their total equity (book value) and the exchange they're listed on (bonus). The scatter plot is color-coded by exchange. Doing it by sector, country, or industry didn't yield conclusive insights.

<details>
    <summary>Click to reveal SQL query</summary>
    ```sql
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
        cd.market_cap > 1e5
        AND bsf.total_stockholders_equity > 1e5
    ORDER BY
        cd.market_cap DESC;
    ```
</details>

As expected, there is a robust positive correlation between market cap and total equity. Companies listed on NYSE tend to dominate the large-cap spectrum, while NASDAQ hosts most of the smaller caps. Judging solely on the comparison of market cap with total equity, NASDAQ-listed companies, especially smaller caps, appear relatively more overvalued compared to the firms listed on NYSE.

![Market cap vs total equity chart](/images/market_cap_vs_total_equity.jpg)
*Scatter plot comparing the market capitalization vs total equity of companies, with a logarithmic scale on both axis.*

<br> <!-- Line break -->

### What's the distribution of return on equity (ROE) across all firms?
The ROE ratio is obtained by dividing net income by the average total equity of the company. We need to gather both of those for each company and make the division. It's worth noting that negative total equity is not considered valid for this calculation, unlike negative net income.

<details>
    <summary>Click to reveal SQL query</summary>
    ```sql
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
    ```
</details>

Upon examination, it's evident that the majority of companies exhibit ROE values falling within the range of 0 to 0.5. However, a substantial portion of companies displays negative ROE, due to negative net income.

![ROE across companies chart](/images/roe_across_companies.jpg)
*Histogram of the distribution of return on equity across all companies.*

<br> <!-- Line break -->

### What's the distribution of the price-to-earnings (P/E) on each sector? 
Price-to-earnings ratio is the result of division of the share price by the earnings per share of the firm. We need each company and also the respective sector name, along with its P/E ratio.

<details>
    <summary>Click to reveal SQL query</summary>
    ```sql
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
        AND cd.market_cap / cosf.net_income BETWEEN 1e-4 AND 1e4
    ORDER BY
        price_to_earnings DESC;
    ```
</details>

The chart suggests that the market is more interested in the technology, telecommunications, health care, and real estate sectors, while energy and finance stocks appear to get less attention from investors.

![Sectors price-to-earnings chart](/images/sectors_price_to_earnings.jpg)
*Box plot of the distribution of price-to-earnings ratio across each sector, ordered by third quartiles, with a logarithmic scale on the y-axis.*

<br> <!-- Line break -->

### What's the relationship between the total equity and return on assets (ROA)?
The ROA is obtained by dividing the net income by the average total assets of the company. For this, we need the companies, their total equity and their ROA.

<details>
    <summary>Click to reveal SQL query</summary>
    ```sql
    SELECT
        cd.company_name,
        bsf.total_stockholders_equity,
        cosf.net_income / bsf.total_assets AS return_on_assets
        -- It should be the average of total assets, although there's not enough data
    FROM
        companies_dim cd
    LEFT JOIN
        consolidated_operations_statements_fact cosf ON cd.company_id = cosf.company_id
    LEFT JOIN
        balance_sheets_fact bsf ON cd.company_id = bsf.company_id
    WHERE
        bsf.total_stockholders_equity > 1e6
        AND cosf.net_income / bsf.total_assets BETWEEN -2 AND 0.5
    ORDER BY
        bsf.total_stockholders_equity DESC;
    ```
</details>

The chart reveals that: as companies scale up in equity, ROA tends to become less negative. This pattern becomes particularly evident as companies surpass the $1 billion in equity mark, suggesting improved efficiency, possibly due to better management.

![Total equity vs ROA chart](/images/total_equity_vs_roa.jpg)
*Scatter plot comparing the total equity vs return on assets of companies, with a logarithmic scale on the x-axis.*

<br> <!-- Line break -->

### What are the top 10 semiconductor firms by cash return on assets (Cash ROA)?
The Cash ROA is obtained by dividing operating cash flow by the average total assets of the company. We need to select the companies from the semiconductor industry and their Cash ROA.

<details>
    <summary>Click to reveal SQL query</summary>
    ```sql
    SELECT
        cd.company_name,
        csf.net_cash_provided_by_operating_activities / bsf.total_assets AS cash_return_on_assets
        -- It should be the average of total assets, although there's not enough data
    FROM
        companies_dim cd
    LEFT JOIN
        cashflow_statements_fact csf ON cd.company_id = csf.company_id
    LEFT JOIN
        balance_sheets_fact bsf ON cd.company_id = bsf.company_id
    LEFT JOIN
        industries_dim id ON cd.industry_id = id.industry_id
    WHERE
        id.industry_name = 'Semiconductors'
        AND csf.net_cash_provided_by_operating_activities IS NOT NULL
        AND bsf.total_assets > 0
    ORDER BY
        cash_return_on_assets DESC
    LIMIT 10;
    ```
</details>

Among these firms, all exhibit impressive Cash ROA metrics. Topping the list is "Nvidia", showcasing exceptional efficiency compared to its counterparts. "Lattice Semiconductor" follows behind by about 10 percentage points, also demonstrating very strong performance in this metric.

![Top semiconductors Cash ROA chart](/images/top_semiconductors_cash_roa.jpg)
*Bar chart displaying the top 10 semiconductor companies by cash return on assets.*

<br> <!-- Line break -->

### What are the average cash flows of firms based on their IPO decade?
To get this we need to group companies by their IPO decade, and get the average cash flows for each group. Decades with five or less companies are excluded from the analysis.

<details>
    <summary>Click to reveal SQL query</summary>
    ```sql
    -- Get the decade ranges as a temporary table
    WITH ipo_decade_ranges AS (
        SELECT 
            GENERATE_SERIES(1920, 2020, 10) AS decade_start,
            GENERATE_SERIES(1929, 2029, 10) AS decade_end
    )

    -- Get the average cash flows of companies based on their IPO decade
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
        cashflow_statements_fact csf ON cd.company_id = csf.company_id
    WHERE
        cd.ipo_year IS NOT NULL
    GROUP BY 
        ipo_decade
    HAVING
        COUNT(cd.company_id) > 5
    ORDER BY 
        ipo_decade;
    ```
</details>

The chart reveals a trend where more recent entrants into the market tend to experience a lower operating cash flow, accompanied by higher investing and financing cash flows, resulting in a lower net cash flow. Unsurprisingly, older companies show a superior average of net cash flow compared to newer entrants.

![Cash flows IPO decade chart](/images/cashflows_ipo_decade.jpg)
*Line chart of the average cash flows (operating, investing, financing and net) of companies based on their IPO decade.*

<br> <!-- Line break -->

### Which firms of most illiquid industries have the lowest operating cash flow?
First, we need to identify the most illiquid industries which, for this analysis, have an average current ratio (current assets divided by current liabilities) below 0.75. Within these industries, we select all of their companies and sort them by the lowest operating cash flow.

<details>
    <summary>Click to reveal SQL query</summary>
    ```sql
    -- Get the most illiquid industries as a temporary table
    WITH most_illiquid_industries AS (
        SELECT
            id.industry_id,
            AVG(bsf.current_assets / bsf.total_current_liabilities) AS current_ratio
        FROM
            industries_dim id
        INNER JOIN
            companies_dim cd ON id.industry_id = cd.industry_id
        INNER JOIN
            balance_sheets_fact bsf ON cd.company_id = bsf.company_id
        WHERE
            id.industry_name IS NOT NULL
            AND bsf.current_assets > 0
            AND bsf.total_current_liabilities > 0
        GROUP BY
            id.industry_id
        HAVING
            AVG(bsf.current_assets / bsf.total_current_liabilities) < 0.75
    )

    -- Get the companies from those industries with the lowest operating cash flow
    SELECT
        cd.company_name,
        csf.net_cash_provided_by_operating_activities AS operating_cashflow
    FROM
        most_illiquid_industries mi
    LEFT JOIN
        companies_dim cd ON mi.industry_id = cd.industry_id
    LEFT JOIN
        cashflow_statements_fact csf ON cd.company_id = csf.company_id
    WHERE
        csf.net_cash_provided_by_operating_activities IS NOT NULL
    ORDER BY
        operating_cashflow
    LIMIT 10;
    ```
</details>

Industries such as entertainment and leasing exhibit significant illiquidity. Among these industries, "AMC Entertainment" emerges as the leader with the poorest operating cash flow, closely followed by "fuboTV".

![Bottom cash flow illiquid chart](/images/bottom_cashflow_illiquid.jpg)
*Bar chart of the bottom 10 companies by operating cash flow, from the most illiquid industries.*

<br> <!-- Line break -->

### Which of the top 10 biotech firms with best gross margin, have the lowest price-to-research (PRR)?
We start by compiling data on biotechnology companies and their respective gross margins, calculated as total sales minus cost of goods sold (COGS) divided by total sales, while also making sure that they have expenses on research and development (R&D). From this pool, the top 10 companies with the highest gross margins are selected. Finally, we get the PRR of these, by dividing market cap by expenses on R&D, ordering the results by the lowest PRR.

<details>
    <summary>Click to reveal SQL query</summary>
    ```sql
    -- Get the top 10 biotechnology companies by gross margin as a temporary table
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

    -- Get those 10 companies ordered by lowest price-to-research
    SELECT
        company_name,
        market_cap / research_and_development_expenses AS price_to_research
    FROM
        top_biotech_by_gross_margin
    ORDER BY
        price_to_research;
    ```
</details>

Interestingly, despite ranking among the top 10 biotech companies by gross margin, "Clearside Biomedical" and "Deciphera Pharmaceuticals" appear to attract relatively low market interest for their level of R&D expenses.

![Top biotech gm PRR chart](/images/top_biotech_gm_prr.jpg)
*Bar chart of the price-to-research from the top 10 biotechnology companies by gross margin.*

## License
GNU General Public License v3.0.
