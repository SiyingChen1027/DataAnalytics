-- Author: Siying Chen
CREATE TABLE ff_5 AS
SELECT
    CONCAT(LEFT(date, 4), '-', RIGHT(date, 2)) AS month,
    LEFT(date, 4) AS year, 
    Mkt_RF,
    SMB,
    HML,
    RMW,
    CMA,
    RF
FROM
    bus211a.ff_5_factors;

DELETE FROM ff_5 WHERE month IS NULL;
ALTER TABLE ff_5 ADD PRIMARY KEY (month);

-- Set up foreign key
ALTER TABLE monthly_return_and_volatility 
ADD CONSTRAINT fk_month_ff5 FOREIGN KEY (month) REFERENCES ff_5 (month);

-- Change column type
ALTER TABLE ff_5 MODIFY year INT(5);

-- Add index, processed already, no need to run again
-- ALTER TABLE ff_5 ADD INDEX idx_year (year);

-- Double check constraints, testing only
-- SELECT 
--     CONSTRAINT_NAME, 
--     TABLE_NAME, 
--     COLUMN_NAME, 
--     REFERENCED_TABLE_NAME, 
--     REFERENCED_COLUMN_NAME 
-- FROM 
--     INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
-- WHERE 
--     TABLE_NAME = 'ff_5'
--     OR REFERENCED_TABLE_NAME = 'ff_5';
-- 