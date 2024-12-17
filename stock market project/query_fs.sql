-- Create a new table financial_statement_v2 and retain the original data
CREATE TABLE financial_statement_v2 AS
SELECT
    stock_id,  -- Stock ID
    year,  -- Year
    revenue,  -- Revenue
    gross_profit,  -- Gross Profit
    operating_income_ebit AS operating_income,  -- Operating Income (EBIT)
    net_income,  -- Net Income
    eps,  -- Earnings Per Share (EPS)
    total_assets,  -- Total Assets
    total_liabilities,  -- Total Liabilities
    se AS shareholders_equity,  -- Shareholders' Equity
    current_ratio,  -- Current Ratio
    debt_to_equity_ratio,  -- Debt-to-Equity Ratio
    ocf,  -- Operating Cash Flow
    capex,  -- Capital Expenditures
    fcf,  -- Free Cash Flow
    roe,  -- Return on Equity (ROE)
    roa,  -- Return on Assets (ROA)
    pe,  -- Price-to-Earnings (P/E) Ratio
    pb  -- Price-to-Book (P/B) Ratio
FROM
    financial_statement;
