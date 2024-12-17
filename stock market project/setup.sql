-- Author: Siying Chen
-- Initialization, run one time only
-- Step 1: Add a new column "Stock_ID" with the value 'BAC'
ALTER TABLE bus211a.bac_origin ADD COLUMN stock_id VARCHAR(10);
ALTER TABLE bus211a.jnj_origin ADD COLUMN stock_id VARCHAR(10);
ALTER TABLE bus211a.msft_origin ADD COLUMN stock_id VARCHAR(10);
ALTER TABLE bus211a.wmt_origin ADD COLUMN stock_id VARCHAR(10);

-- Step 2: Update the new "Stock_ID" column with a constant value 'BAC' for Bank of America
UPDATE bus211a.bac_origin SET stock_id = 'BAC';
UPDATE bus211a.jnj_origin SET stock_id = 'JNJ';
UPDATE bus211a.msft_origin SET stock_id = 'MSFT';
UPDATE bus211a.wmt_origin SET stock_id = 'WMT';

-- Step 3: Create a new table "BAC" with only the required columns
CREATE TABLE bus211a.bac AS 
SELECT 
    stock_id,
    date,
    'Bank of America' AS stock_Name,
		`Return` AS `daily_return`
FROM bus211a.bac_origin;

CREATE TABLE bus211a.jnj AS 
SELECT 
    stock_id,
    date,
    'Johnson & Johnson' AS stock_Name,
		`Return` AS `daily_return`
FROM bus211a.jnj_origin;

CREATE TABLE bus211a.msft AS 
SELECT 
    stock_id,
    date,
    'Microsoft' AS stock_Name,
		`Return` AS `daily_return`
FROM bus211a.msft_origin;

CREATE TABLE bus211a.wmt AS 
SELECT 
    stock_id,
    date,
    'Walmart' AS stock_Name,
		`Return` AS `daily_return`
FROM bus211a.wmt_origin;


-- Clean, delete empty dates
DELETE FROM bac WHERE date IS NULL;
DELETE FROM jnj WHERE date IS NULL;
DELETE FROM msft WHERE date IS NULL;
DELETE FROM wmt WHERE date IS NULL;

-- Set primary key and foreign key
ALTER TABLE bac ADD PRIMARY KEY (stock_id, date);
ALTER TABLE jnj ADD PRIMARY KEY (stock_id, date);
ALTER TABLE msft ADD PRIMARY KEY (stock_id, date);
ALTER TABLE wmt ADD PRIMARY KEY (stock_id, date);
ALTER TABLE monthly_return_and_volatility ADD PRIMARY KEY (stock_id, month);
ALTER TABLE yearly_return_and_volatility ADD PRIMARY KEY (stock_id, year);