USE bus211a;
-- Identifying stocks with missing financial data
SELECT s.Stock_ID,
       CONCAT(s.Stock_Name, ' - ', s.Stock_ID) AS stock_info,
       f.year AS year,
       IF(f.capex = 0, 'NULL', f.capex) AS capex_status
FROM stocks s
RIGHT JOIN financial_statement_v2 f ON s.Stock_ID = f.stock_id
WHERE f.capex = 0;

-- Select stocks with daily returns between -0.025 and 0.025
SELECT stock_id, daily_return
FROM daily_return_and_volatility
WHERE daily_return BETWEEN -0.025 AND 0.025;

-- Select stocks with daily return greater than 0.025 or less than -0.025
SELECT stock_id, daily_return
FROM daily_return_and_volatility
WHERE daily_return > 0.025 OR daily_return < -0.025;

-- Use subquery in the FROM clause to fliter a stock
SELECT stock_id, avg_daily_return
FROM (
    SELECT stock_id, AVG(daily_return) AS avg_daily_return
    FROM daily_return_and_volatility
    GROUP BY stock_id
) AS subquery
HAVING avg_daily_return > 0.001;

-- Select returns greater than average and filter by stock name starting with 'M'
SELECT stock_id, daily_return
FROM daily_return_and_volatility
WHERE daily_return > (SELECT AVG(daily_return) FROM daily_return_and_volatility)
AND stock_id IN (SELECT stock_id FROM stocks WHERE stock_name LIKE 'M%');

-- Classifying stocks based on return categories
SELECT return_category,
       COUNT(*) AS stock_count
FROM (
    SELECT stock_id,
           CASE
               WHEN yearly_return > 0.2 THEN 'High Return'
               WHEN yearly_return BETWEEN 0.05 AND 0.2 THEN 'Moderate Return'
               ELSE 'Low Return'
           END AS return_category
    FROM yearly_return_and_volatility
) AS categorized_stocks
GROUP BY return_category
HAVING COUNT(*) > 3;

-- VaR Percentile calculation using two methods
WITH stock_counts AS (
    SELECT stock_id, COUNT(*) AS total_count
    FROM daily_return_and_volatility
    GROUP BY stock_id
),
ranked_returns AS (
    SELECT drv.stock_id, drv.daily_return,
           ROW_NUMBER() OVER (PARTITION BY drv.stock_id ORDER BY drv.daily_return) AS `rank`,
           sc.total_count
    FROM daily_return_and_volatility drv
    JOIN stock_counts sc ON drv.stock_id = sc.stock_id
),
VaR_Historical AS (
    SELECT stock_id, daily_return AS VaR_95_Historical_Method
    FROM ranked_returns
    WHERE `rank` = FLOOR(0.05 * total_count)
),
stats AS (
    SELECT stock_id,
           AVG(daily_return) AS mean_return,
           STDDEV(daily_return) AS stddev_return
    FROM daily_return_and_volatility
    GROUP BY stock_id
),
VaR_STD AS (
    SELECT stock_id,
           mean_return - 1.65 * stddev_return AS VaR_95_STD_Method
    FROM stats
)
SELECT h.stock_id, h.VaR_95_Historical_Method, s.VaR_95_STD_Method
FROM VaR_Historical h
JOIN VaR_STD s ON h.stock_id = s.stock_id;

-- Combine yearly max and min return data for analysis using UNION
SELECT stock_id,
       MAX(yearly_return) AS return_value,
       'Max Return' AS return_type
FROM yearly_return_and_volatility
GROUP BY stock_id
UNION
SELECT stock_id,
       MIN(yearly_return) AS return_value,
       'Min Return' AS return_type
FROM yearly_return_and_volatility
GROUP BY stock_id;

-- Analyze max, min, and volatility for all stocks and filter to show only MSFT data using IN function
SELECT CONCAT(s.Stock_ID, ' - ', s.Stock_Name) AS stock_info,
       SUBSTRING(s.Stock_Name, 1, 3) AS stock_prefix,
       MAX(y.yearly_return) AS max_yearly_return,
       MIN(y.yearly_return) AS min_yearly_return,
       POWER(AVG(y.yearly_volatility), 2) AS volatility_squared,
       SQRT(POWER(AVG(y.yearly_volatility), 2)) AS volatility_sqrt
FROM yearly_return_and_volatility y
JOIN stocks s ON y.stock_ID = s.Stock_ID
WHERE s.Stock_ID IN ('MSFT') 
GROUP BY s.Stock_ID, s.Stock_Name;

-- Calculate Sharpe ratio for each year
SELECT 
    stock_id,
    MAX(CASE WHEN year = 2019 THEN (yearly_return - 0.02) / yearly_volatility END) AS sharpe_ratio_2019,
    MAX(CASE WHEN year = 2020 THEN (yearly_return - 0.02) / yearly_volatility END) AS sharpe_ratio_2020,
    MAX(CASE WHEN year = 2021 THEN (yearly_return - 0.02) / yearly_volatility END) AS sharpe_ratio_2021,
    MAX(CASE WHEN year = 2022 THEN (yearly_return - 0.02) / yearly_volatility END) AS sharpe_ratio_2022,
    MAX(CASE WHEN year = 2023 THEN (yearly_return - 0.02) / yearly_volatility END) AS sharpe_ratio_2023
FROM yearly_return_and_volatility
GROUP BY stock_id
ORDER BY stock_id;

-- Calculate rolling average return
WITH ordered_data AS (
    SELECT stock_id, daily_return,
           ROW_NUMBER() OVER (PARTITION BY stock_id ORDER BY stock_id) AS row_num
    FROM daily_return_and_volatility
)
SELECT stock_id, daily_return, 
       AVG(daily_return) OVER (PARTITION BY stock_id ORDER BY row_num ROWS 4 PRECEDING) AS rolling_avg_return
FROM ordered_data;

-- Select distinct stock IDs with their most recent year net income
SELECT DISTINCT stock_id, 
       FIRST_VALUE(year) OVER (PARTITION BY stock_id ORDER BY year DESC) AS latest_year,
       FIRST_VALUE(net_income) OVER (PARTITION BY stock_id ORDER BY year DESC) AS latest_net_income
FROM financial_statement_v2;

-- Use INNER JOIN to combine return and revenue
SELECT f.stock_id, f.year, f.revenue, y.yearly_return
FROM financial_statement_v2 f
INNER JOIN yearly_return_and_volatility y
ON f.stock_id = y.stock_id AND f.year = y.year;

-- Using USING to join to combine gross_profit and revenue
SELECT f.stock_id, f.year, f.gross_profit, y.yearly_return
FROM financial_statement_v2 f
JOIN yearly_return_and_volatility y USING (stock_id, year);

-- Using LEFT JOIN to match capex with yearly_return, and treat capex = 0 as NULL
SELECT f.stock_id, f.year, 
       CASE WHEN f.capex = 0 THEN NULL ELSE f.capex END AS capex, 
       y.yearly_return
FROM financial_statement_v2 f
LEFT JOIN yearly_return_and_volatility y
ON f.stock_id = y.stock_id AND f.year = y.year;

