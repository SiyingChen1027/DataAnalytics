-- Author: Siying Chen
-- BOA
CREATE TABLE monthly_return_and_volatility AS
SELECT 
    stock_id,
    DATE_FORMAT(date, '%Y-%m') AS month,
    EXP(SUM(LOG(1 + IFNULL(daily_return, 0)))) - 1 AS monthly_return,
    STDDEV(IFNULL(daily_return, 0)) * SQRT(21) AS monthly_volatility
FROM 
    bus211a.bac
GROUP BY 
    stock_id, month;

-- JNJ
INSERT INTO monthly_return_and_volatility (stock_id, month, monthly_return, monthly_volatility)
SELECT 
    stock_id,
    DATE_FORMAT(date, '%Y-%m') AS month,
    EXP(SUM(LOG(1 + IFNULL(daily_return, 0)))) - 1 AS monthly_return,
    STDDEV(IFNULL(daily_return, 0)) * SQRT(21) AS monthly_volatility
FROM 
    bus211a.jnj
GROUP BY 
    stock_id, month;

-- MSFT
INSERT INTO monthly_return_and_volatility (stock_id, month, monthly_return, monthly_volatility)
SELECT 
    stock_id,
    DATE_FORMAT(date, '%Y-%m') AS month,
    EXP(SUM(LOG(1 + IFNULL(daily_return, 0)))) - 1 AS monthly_return,
    STDDEV(IFNULL(daily_return, 0)) * SQRT(21) AS monthly_volatility
FROM 
    bus211a.msft
GROUP BY 
    stock_id, month;

-- WMT
INSERT INTO monthly_return_and_volatility (stock_id, month, monthly_return, monthly_volatility)
SELECT 
    stock_id,
    DATE_FORMAT(date, '%Y-%m') AS month,
    EXP(SUM(LOG(1 + IFNULL(daily_return, 0)))) - 1 AS monthly_return,
    STDDEV(IFNULL(daily_return, 0)) * SQRT(21) AS monthly_volatility
FROM 
    bus211a.wmt
GROUP BY 
    stock_id, month;
		
-- Delete empty rows
DELETE FROM monthly_return_and_volatility
WHERE month IS NULL;

