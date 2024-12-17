-- Author: Siying Chen
-- BAC
CREATE TABLE yearly_return_and_volatility AS
SELECT 
    stock_id,
    YEAR(date) AS year,
    EXP(SUM(LOG(1 + daily_return))) - 1 AS yearly_return,
    STDDEV(IFNULL(daily_return, 0))  SQRT(252) AS yearly_volatility
FROM 
    bus211a.bac
WHERE 
    daily_return IS NOT NULL  -- 过滤掉没有回报率的记录
GROUP BY 
    stock_id, year;
		
-- JNJ
INSERT INTO yearly_return_and_volatility (stock_id, year, yearly_return, yearly_volatility)
SELECT 
    stock_id,
    YEAR(date) AS year,
    EXP(SUM(LOG(1 + daily_return))) - 1 AS yearly_return,
    STDDEV(IFNULL(daily_return, 0))  SQRT(252) AS yearly_volatility
FROM 
    bus211a.jnj
WHERE 
    daily_return IS NOT NULL  -- 过滤掉没有回报率的记录
GROUP BY 
    stock_id, year;
		
-- MSFT
INSERT INTO yearly_return_and_volatility (stock_id, year, yearly_return, yearly_volatility)
SELECT 
    stock_id,
    YEAR(date) AS year,
    EXP(SUM(LOG(1 + daily_return))) - 1 AS yearly_return,
    STDDEV(IFNULL(daily_return, 0))  SQRT(252) AS yearly_volatility
FROM 
    bus211a.msft
WHERE 
    daily_return IS NOT NULL  -- 过滤掉没有回报率的记录
GROUP BY 
    stock_id, year;

-- wmt
INSERT INTO yearly_return_and_volatility (stock_id, year, yearly_return, yearly_volatility)
SELECT 
    stock_id,
    YEAR(date) AS year,
    EXP(SUM(LOG(1 + daily_return))) - 1 AS yearly_return,
    STDDEV(IFNULL(daily_return, 0))  SQRT(252) AS yearly_volatility
FROM 
    bus211a.wmt
WHERE 
    daily_return IS NOT NULL  -- 过滤掉没有回报率的记录
GROUP BY 
    stock_id, year;
