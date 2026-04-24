USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE WAREHOUSE FINSERV_HOL_WH
  WAREHOUSE_SIZE = 'SMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

CREATE OR REPLACE DATABASE FINSERV_HOL_DB;
CREATE OR REPLACE SCHEMA FINSERV_HOL_DB.PORTFOLIO;
CREATE OR REPLACE SCHEMA FINSERV_HOL_DB.RISK;

CREATE OR REPLACE ROLE FINSERV_HOL_ROLE;
GRANT USAGE ON WAREHOUSE FINSERV_HOL_WH TO ROLE FINSERV_HOL_ROLE;
GRANT ALL ON DATABASE FINSERV_HOL_DB TO ROLE FINSERV_HOL_ROLE;
GRANT ALL ON ALL SCHEMAS IN DATABASE FINSERV_HOL_DB TO ROLE FINSERV_HOL_ROLE;
GRANT ROLE FINSERV_HOL_ROLE TO ROLE ACCOUNTADMIN;

USE DATABASE FINSERV_HOL_DB;
USE SCHEMA PORTFOLIO;
USE WAREHOUSE FINSERV_HOL_WH;

CREATE OR REPLACE STAGE FINSERV_HOL_DB.PORTFOLIO.PDF_STAGE
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

CREATE OR REPLACE STAGE FINSERV_HOL_DB.PORTFOLIO.SEMANTIC_MODELS_STAGE
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

CREATE OR REPLACE TABLE FINSERV_HOL_DB.PORTFOLIO.ADVISORS (
  ADVISOR_ID INTEGER,
  FIRST_NAME VARCHAR(50),
  LAST_NAME VARCHAR(50),
  REGION VARCHAR(50),
  CERTIFICATION VARCHAR(50),
  HIRE_DATE DATE,
  STATUS VARCHAR(20),
  AUM_TARGET NUMBER(15,2)
);

INSERT INTO FINSERV_HOL_DB.PORTFOLIO.ADVISORS VALUES
(1, 'Alexandra', 'Morgan', 'Northeast', 'CFA', '2010-03-15', 'Active', 500000000.00),
(2, 'Benjamin', 'Hayes', 'Southeast', 'CFP', '2015-07-01', 'Active', 300000000.00),
(3, 'Catherine', 'Wells', 'West', 'CFA', '2012-01-10', 'Active', 450000000.00),
(4, 'David', 'Chen', 'Northeast', 'CAIA', '2018-05-20', 'Active', 200000000.00),
(5, 'Elizabeth', 'Foster', 'Midwest', 'CFP', '2014-09-12', 'Active', 350000000.00),
(6, 'Franklin', 'Reeves', 'West', 'CFA', '2008-11-30', 'Active', 600000000.00),
(7, 'Grace', 'Kim', 'Southeast', 'CFP', '2020-02-14', 'Active', 150000000.00),
(8, 'Henry', 'Patel', 'Northeast', 'CFA', '2016-06-01', 'Active', 400000000.00);

CREATE OR REPLACE TABLE FINSERV_HOL_DB.PORTFOLIO.CLIENTS (
  CLIENT_ID INTEGER,
  FIRST_NAME VARCHAR(50),
  LAST_NAME VARCHAR(50),
  CLIENT_TYPE VARCHAR(30),
  RISK_TOLERANCE VARCHAR(20),
  ADVISOR_ID INTEGER,
  ONBOARD_DATE DATE,
  STATUS VARCHAR(20),
  ANNUAL_INCOME NUMBER(12,2),
  NET_WORTH NUMBER(15,2)
);

INSERT INTO FINSERV_HOL_DB.PORTFOLIO.CLIENTS VALUES
(1, 'William', 'Thompson', 'Individual', 'Aggressive', 1, '2018-03-10', 'Active', 350000.00, 4500000.00),
(2, 'Margaret', 'Sullivan', 'Individual', 'Moderate', 1, '2019-06-22', 'Active', 180000.00, 2200000.00),
(3, 'Richard', 'Nakamura', 'Trust', 'Conservative', 3, '2015-01-15', 'Active', 0.00, 12000000.00),
(4, 'Jennifer', 'O''Brien', 'Individual', 'Aggressive', 2, '2020-09-05', 'Active', 420000.00, 3800000.00),
(5, 'Thomas', 'Weber', 'Corporate', 'Moderate', 5, '2017-04-18', 'Active', 0.00, 8500000.00),
(6, 'Sarah', 'Blackwell', 'Individual', 'Conservative', 4, '2021-11-01', 'Active', 95000.00, 850000.00),
(7, 'Robert', 'Chang', 'Individual', 'Aggressive', 6, '2016-08-30', 'Active', 500000.00, 6200000.00),
(8, 'Patricia', 'Mendez', 'Trust', 'Moderate', 3, '2014-02-20', 'Active', 0.00, 15000000.00),
(9, 'James', 'Stewart', 'Individual', 'Moderate', 8, '2019-12-10', 'Active', 220000.00, 1800000.00),
(10, 'Elizabeth', 'Kwan', 'Individual', 'Aggressive', 1, '2017-07-14', 'Active', 380000.00, 5100000.00),
(11, 'Michael', 'Rivera', 'Corporate', 'Moderate', 5, '2018-10-25', 'Active', 0.00, 22000000.00),
(12, 'Laura', 'Hoffman', 'Individual', 'Conservative', 7, '2022-03-08', 'Active', 125000.00, 980000.00),
(13, 'Daniel', 'Brooks', 'Individual', 'Moderate', 2, '2016-05-12', 'Active', 275000.00, 3200000.00),
(14, 'Anna', 'Petrov', 'Trust', 'Conservative', 8, '2013-09-30', 'Active', 0.00, 18000000.00),
(15, 'Christopher', 'Owens', 'Individual', 'Aggressive', 6, '2020-01-20', 'Active', 450000.00, 4800000.00),
(16, 'Maria', 'Santos', 'Individual', 'Moderate', 4, '2021-06-15', 'Active', 160000.00, 1200000.00),
(17, 'Andrew', 'Phillips', 'Corporate', 'Aggressive', 1, '2015-11-08', 'Active', 0.00, 35000000.00),
(18, 'Karen', 'Nguyen', 'Individual', 'Conservative', 7, '2023-01-05', 'Active', 88000.00, 650000.00),
(19, 'Matthew', 'Hayes', 'Individual', 'Moderate', 3, '2018-07-22', 'Active', 310000.00, 2800000.00),
(20, 'Rachel', 'Cohen', 'Individual', 'Aggressive', 8, '2019-04-10', 'Active', 400000.00, 5500000.00),
(21, 'Joseph', 'Burke', 'Trust', 'Moderate', 6, '2012-08-15', 'Active', 0.00, 25000000.00),
(22, 'Samantha', 'Lewis', 'Individual', 'Conservative', 2, '2022-09-18', 'Active', 105000.00, 720000.00),
(23, 'Brian', 'Torres', 'Individual', 'Moderate', 5, '2017-03-05', 'Active', 240000.00, 2500000.00),
(24, 'Nicole', 'Armstrong', 'Individual', 'Aggressive', 4, '2020-12-01', 'Active', 520000.00, 7200000.00),
(25, 'Timothy', 'Walsh', 'Corporate', 'Conservative', 3, '2016-02-28', 'Active', 0.00, 45000000.00);

CREATE OR REPLACE TABLE FINSERV_HOL_DB.PORTFOLIO.ACCOUNTS (
  ACCOUNT_ID INTEGER,
  CLIENT_ID INTEGER,
  ACCOUNT_TYPE VARCHAR(30),
  ACCOUNT_NAME VARCHAR(100),
  OPEN_DATE DATE,
  STATUS VARCHAR(20),
  BALANCE NUMBER(15,2)
);

INSERT INTO FINSERV_HOL_DB.PORTFOLIO.ACCOUNTS VALUES
(1, 1, 'Brokerage', 'Thompson Growth', '2018-03-10', 'Active', 2800000.00),
(2, 1, 'IRA', 'Thompson Retirement', '2018-03-10', 'Active', 1200000.00),
(3, 2, 'Brokerage', 'Sullivan Balanced', '2019-06-22', 'Active', 1500000.00),
(4, 3, 'Trust', 'Nakamura Family Trust', '2015-01-15', 'Active', 12000000.00),
(5, 4, 'Brokerage', 'O''Brien Aggressive Growth', '2020-09-05', 'Active', 2200000.00),
(6, 5, 'Corporate', 'Weber Industries Pension', '2017-04-18', 'Active', 8500000.00),
(7, 6, 'IRA', 'Blackwell Retirement', '2021-11-01', 'Active', 650000.00),
(8, 7, 'Brokerage', 'Chang High Growth', '2016-08-30', 'Active', 4500000.00),
(9, 8, 'Trust', 'Mendez Family Trust', '2014-02-20', 'Active', 15000000.00),
(10, 9, 'Brokerage', 'Stewart Moderate', '2019-12-10', 'Active', 1100000.00),
(11, 10, 'Brokerage', 'Kwan Aggressive', '2017-07-14', 'Active', 3200000.00),
(12, 11, 'Corporate', 'Rivera Corp 401k', '2018-10-25', 'Active', 22000000.00),
(13, 12, 'IRA', 'Hoffman Retirement', '2022-03-08', 'Active', 580000.00),
(14, 13, 'Brokerage', 'Brooks Balanced', '2016-05-12', 'Active', 2400000.00),
(15, 14, 'Trust', 'Petrov Family Trust', '2013-09-30', 'Active', 18000000.00),
(16, 15, 'Brokerage', 'Owens Growth', '2020-01-20', 'Active', 3500000.00),
(17, 16, 'Brokerage', 'Santos Moderate', '2021-06-15', 'Active', 850000.00),
(18, 17, 'Corporate', 'Phillips Holdings Fund', '2015-11-08', 'Active', 35000000.00),
(19, 18, 'IRA', 'Nguyen Retirement', '2023-01-05', 'Active', 420000.00),
(20, 19, 'Brokerage', 'Hayes Growth', '2018-07-22', 'Active', 2000000.00),
(21, 20, 'Brokerage', 'Cohen Aggressive', '2019-04-10', 'Active', 3800000.00),
(22, 21, 'Trust', 'Burke Charitable Trust', '2012-08-15', 'Active', 25000000.00),
(23, 22, 'IRA', 'Lewis Retirement', '2022-09-18', 'Active', 480000.00),
(24, 23, 'Brokerage', 'Torres Balanced', '2017-03-05', 'Active', 1800000.00),
(25, 24, 'Brokerage', 'Armstrong Growth', '2020-12-01', 'Active', 5200000.00),
(26, 25, 'Corporate', 'Walsh Industries Fund', '2016-02-28', 'Active', 45000000.00);

CREATE OR REPLACE TABLE FINSERV_HOL_DB.PORTFOLIO.SECURITIES (
  SECURITY_ID INTEGER,
  TICKER VARCHAR(10),
  SECURITY_NAME VARCHAR(100),
  ASSET_CLASS VARCHAR(30),
  SECTOR VARCHAR(50),
  CURRENT_PRICE NUMBER(10,2),
  MARKET_CAP_B NUMBER(10,2),
  DIVIDEND_YIELD NUMBER(5,2),
  BETA NUMBER(5,2)
);

INSERT INTO FINSERV_HOL_DB.PORTFOLIO.SECURITIES VALUES
(1, 'AAPL', 'Apple Inc', 'Equity', 'Technology', 228.50, 3520.00, 0.44, 1.24),
(2, 'MSFT', 'Microsoft Corp', 'Equity', 'Technology', 448.20, 3340.00, 0.72, 0.89),
(3, 'GOOGL', 'Alphabet Inc', 'Equity', 'Technology', 178.30, 2200.00, 0.00, 1.06),
(4, 'AMZN', 'Amazon.com Inc', 'Equity', 'Consumer Discretionary', 198.40, 2050.00, 0.00, 1.15),
(5, 'JNJ', 'Johnson & Johnson', 'Equity', 'Healthcare', 155.80, 375.00, 3.12, 0.56),
(6, 'JPM', 'JPMorgan Chase', 'Equity', 'Financials', 248.90, 720.00, 2.08, 1.12),
(7, 'PG', 'Procter & Gamble', 'Equity', 'Consumer Staples', 168.40, 395.00, 2.42, 0.42),
(8, 'UNH', 'UnitedHealth Group', 'Equity', 'Healthcare', 528.60, 485.00, 1.48, 0.78),
(9, 'V', 'Visa Inc', 'Equity', 'Financials', 312.70, 640.00, 0.72, 0.96),
(10, 'XOM', 'Exxon Mobil', 'Equity', 'Energy', 108.50, 458.00, 3.35, 0.82),
(11, 'BRK.B', 'Berkshire Hathaway', 'Equity', 'Financials', 468.30, 1020.00, 0.00, 0.55),
(12, 'NVDA', 'NVIDIA Corp', 'Equity', 'Technology', 890.20, 2200.00, 0.03, 1.68),
(13, 'AGG', 'iShares Core US Aggregate Bond', 'Fixed Income', 'Bonds', 98.50, 0.00, 4.20, 0.05),
(14, 'BND', 'Vanguard Total Bond Market', 'Fixed Income', 'Bonds', 72.80, 0.00, 4.35, 0.04),
(15, 'TLT', 'iShares 20+ Year Treasury', 'Fixed Income', 'Government', 92.40, 0.00, 4.50, 0.15),
(16, 'SPY', 'SPDR S&P 500 ETF', 'Equity', 'Index', 585.20, 0.00, 1.22, 1.00),
(17, 'VWO', 'Vanguard Emerging Markets', 'Equity', 'International', 44.80, 0.00, 3.10, 0.88),
(18, 'GLD', 'SPDR Gold Trust', 'Alternative', 'Commodities', 242.50, 0.00, 0.00, 0.12),
(19, 'VNQ', 'Vanguard Real Estate ETF', 'Alternative', 'Real Estate', 85.30, 0.00, 3.85, 0.92),
(20, 'HYG', 'iShares High Yield Corporate Bond', 'Fixed Income', 'Bonds', 78.20, 0.00, 5.80, 0.35);

CREATE OR REPLACE TABLE FINSERV_HOL_DB.PORTFOLIO.HOLDINGS (
  HOLDING_ID INTEGER,
  ACCOUNT_ID INTEGER,
  SECURITY_ID INTEGER,
  QUANTITY NUMBER(12,4),
  AVG_COST_BASIS NUMBER(10,2),
  CURRENT_VALUE NUMBER(15,2),
  UNREALIZED_PL NUMBER(15,2),
  POSITION_PCT NUMBER(5,2),
  AS_OF_DATE DATE
);

INSERT INTO FINSERV_HOL_DB.PORTFOLIO.HOLDINGS VALUES
(1, 1, 1, 5000.00, 180.00, 1142500.00, 242500.00, 40.80, '2025-04-20'),
(2, 1, 12, 800.00, 450.00, 712160.00, 352160.00, 25.43, '2025-04-20'),
(3, 1, 4, 2000.00, 150.00, 396800.00, 96800.00, 14.17, '2025-04-20'),
(4, 1, 6, 2200.00, 200.00, 547580.00, 107580.00, 19.56, '2025-04-20'),
(5, 2, 16, 1000.00, 420.00, 585200.00, 165200.00, 48.77, '2025-04-20'),
(6, 2, 13, 4000.00, 100.00, 394000.00, -6000.00, 32.83, '2025-04-20'),
(7, 2, 14, 3000.00, 75.00, 218400.00, -6600.00, 18.20, '2025-04-20'),
(8, 3, 5, 3000.00, 160.00, 467400.00, -12600.00, 31.16, '2025-04-20'),
(9, 3, 7, 2500.00, 150.00, 421000.00, 46000.00, 28.07, '2025-04-20'),
(10, 3, 13, 6000.00, 100.00, 591000.00, -9000.00, 39.40, '2025-04-20'),
(11, 4, 4, 1500.00, 130.00, 297600.00, 102600.00, 24.80, '2025-04-20'),
(12, 4, 3, 2000.00, 120.00, 356600.00, 116600.00, 29.72, '2025-04-20'),
(13, 5, 1, 8000.00, 175.00, 1828000.00, 428000.00, 21.51, '2025-04-20'),
(14, 5, 2, 6000.00, 300.00, 2689200.00, 889200.00, 31.64, '2025-04-20'),
(15, 8, 12, 2500.00, 300.00, 2225500.00, 1475500.00, 49.46, '2025-04-20'),
(16, 8, 1, 4000.00, 165.00, 914000.00, 254000.00, 20.31, '2025-04-20'),
(17, 8, 3, 3000.00, 100.00, 534900.00, 234900.00, 11.89, '2025-04-20'),
(18, 9, 5, 20000.00, 140.00, 3116000.00, 316000.00, 20.77, '2025-04-20'),
(19, 9, 7, 15000.00, 145.00, 2526000.00, 351000.00, 16.84, '2025-04-20'),
(20, 9, 8, 8000.00, 400.00, 4228800.00, 1028800.00, 28.19, '2025-04-20'),
(21, 9, 13, 30000.00, 102.00, 2955000.00, -105000.00, 19.70, '2025-04-20'),
(22, 11, 12, 1500.00, 500.00, 1335300.00, 585300.00, 41.73, '2025-04-20'),
(23, 11, 2, 2000.00, 350.00, 896400.00, 196400.00, 28.01, '2025-04-20'),
(24, 15, 14, 80000.00, 74.00, 5824000.00, -96000.00, 32.36, '2025-04-20'),
(25, 15, 15, 50000.00, 95.00, 4620000.00, -130000.00, 25.67, '2025-04-20'),
(26, 15, 13, 40000.00, 101.00, 3940000.00, -100000.00, 21.89, '2025-04-20'),
(27, 18, 1, 50000.00, 160.00, 11425000.00, 3425000.00, 32.64, '2025-04-20'),
(28, 18, 2, 30000.00, 280.00, 13446000.00, 5046000.00, 38.42, '2025-04-20'),
(29, 22, 5, 50000.00, 150.00, 7790000.00, 290000.00, 31.16, '2025-04-20'),
(30, 22, 8, 15000.00, 420.00, 7929000.00, 1629000.00, 31.72, '2025-04-20');

CREATE OR REPLACE TABLE FINSERV_HOL_DB.PORTFOLIO.TRANSACTIONS (
  TRANSACTION_ID INTEGER,
  ACCOUNT_ID INTEGER,
  SECURITY_ID INTEGER,
  TRANSACTION_TYPE VARCHAR(10),
  QUANTITY NUMBER(12,4),
  PRICE NUMBER(10,2),
  TOTAL_AMOUNT NUMBER(15,2),
  TRANSACTION_DATE DATE,
  STATUS VARCHAR(20)
);

INSERT INTO FINSERV_HOL_DB.PORTFOLIO.TRANSACTIONS VALUES
(1, 1, 1, 'Buy', 1000.00, 205.00, 205000.00, '2025-01-15', 'Settled'),
(2, 1, 12, 200.00, 750.00, 150000.00, '2025-01-20', 'Settled'),
(3, 5, 1, 2000.00, 210.00, 420000.00, '2025-01-22', 'Settled'),
(4, 8, 12, 500.00, 680.00, 340000.00, '2025-02-01', 'Settled'),
(5, 3, 13, 2000.00, 99.00, 198000.00, '2025-02-05', 'Settled'),
(6, 4, 3, 500.00, 165.00, 82500.00, '2025-02-10', 'Settled'),
(7, 9, 8, 2000.00, 500.00, 1000000.00, '2025-02-15', 'Settled'),
(8, 11, 12, 300.00, 820.00, 246000.00, '2025-02-20', 'Settled'),
(9, 1, 4, 500.00, 188.00, 94000.00, '2025-03-01', 'Settled'),
(10, 15, 15, 10000.00, 93.00, 930000.00, '2025-03-05', 'Settled'),
(11, 18, 2, 5000.00, 430.00, 2150000.00, '2025-03-10', 'Settled'),
(12, 22, 5, 10000.00, 158.00, 1580000.00, '2025-03-12', 'Settled'),
(13, 5, 2, 1000.00, 440.00, 440000.00, '2025-03-15', 'Settled'),
(14, 8, 1, 1000.00, 220.00, 220000.00, '2025-03-20', 'Settled'),
(15, 1, 6, 500.00, 240.00, 120000.00, '2025-03-25', 'Settled'),
(16, 9, 13, 10000.00, 98.50, 985000.00, '2025-04-01', 'Settled'),
(17, 4, 4, 300.00, 195.00, 58500.00, '2025-04-05', 'Settled'),
(18, 11, 2, 500.00, 445.00, 222500.00, '2025-04-10', 'Settled'),
(19, 3, 5, 800.00, 156.00, 124800.00, '2025-04-12', 'Settled'),
(20, 1, 12, 100.00, 880.00, 88000.00, '2025-04-15', 'Settled'),
(21, 8, 3, 500.00, 175.00, 87500.00, '2025-04-18', 'Settled'),
(22, 18, 1, 10000.00, 225.00, 2250000.00, '2025-04-20', 'Settled'),
(23, 22, 8, 3000.00, 525.00, 1575000.00, '2025-04-10', 'Settled'),
(24, 15, 14, 15000.00, 73.00, 1095000.00, '2025-03-28', 'Settled'),
(25, 5, 16, 500.00, 580.00, 290000.00, '2025-04-08', 'Settled');

CREATE OR REPLACE TABLE FINSERV_HOL_DB.RISK.RISK_SCORES (
  RISK_ID INTEGER,
  ACCOUNT_ID INTEGER,
  RISK_SCORE NUMBER(5,2),
  VAR_95 NUMBER(15,2),
  SHARPE_RATIO NUMBER(5,2),
  MAX_DRAWDOWN_PCT NUMBER(5,2),
  CONCENTRATION_RISK VARCHAR(10),
  ASSESSMENT_DATE DATE
);

INSERT INTO FINSERV_HOL_DB.RISK.RISK_SCORES VALUES
(1, 1, 0.82, 185000.00, 1.45, 12.30, 'High', '2025-04-20'),
(2, 2, 0.35, 42000.00, 0.85, 5.20, 'Low', '2025-04-20'),
(3, 3, 0.28, 38000.00, 0.92, 4.80, 'Low', '2025-04-20'),
(4, 4, 0.78, 125000.00, 1.20, 15.50, 'Medium', '2025-04-20'),
(5, 5, 0.65, 380000.00, 1.55, 9.80, 'Medium', '2025-04-20'),
(6, 6, 0.22, 32000.00, 0.78, 3.50, 'Low', '2025-04-20'),
(7, 7, 0.18, 18000.00, 0.65, 4.10, 'Low', '2025-04-20'),
(8, 8, 0.88, 320000.00, 1.80, 18.20, 'High', '2025-04-20'),
(9, 9, 0.42, 280000.00, 1.10, 6.50, 'Medium', '2025-04-20'),
(10, 10, 0.40, 65000.00, 1.05, 5.80, 'Low', '2025-04-20'),
(11, 11, 0.85, 210000.00, 1.65, 16.80, 'High', '2025-04-20'),
(12, 12, 0.55, 185000.00, 0.95, 7.20, 'Medium', '2025-04-20'),
(13, 13, 0.15, 8000.00, 0.55, 3.20, 'Low', '2025-04-20'),
(14, 14, 0.30, 55000.00, 0.88, 4.50, 'Low', '2025-04-20'),
(15, 15, 0.20, 220000.00, 0.72, 3.80, 'Low', '2025-04-20'),
(16, 16, 0.72, 180000.00, 1.35, 13.50, 'Medium', '2025-04-20'),
(17, 17, 0.38, 48000.00, 0.90, 5.50, 'Low', '2025-04-20'),
(18, 18, 0.70, 1800000.00, 1.60, 11.20, 'High', '2025-04-20'),
(19, 19, 0.12, 6500.00, 0.45, 2.80, 'Low', '2025-04-20'),
(20, 20, 0.45, 95000.00, 1.15, 6.80, 'Medium', '2025-04-20'),
(21, 21, 0.75, 280000.00, 1.40, 14.20, 'High', '2025-04-20'),
(22, 22, 0.32, 450000.00, 0.85, 4.20, 'Low', '2025-04-20'),
(23, 23, 0.14, 9500.00, 0.50, 3.10, 'Low', '2025-04-20'),
(24, 24, 0.50, 120000.00, 1.00, 7.80, 'Medium', '2025-04-20'),
(25, 25, 0.68, 250000.00, 1.30, 10.50, 'Medium', '2025-04-20'),
(26, 26, 0.25, 550000.00, 0.80, 3.90, 'Low', '2025-04-20');

CREATE OR REPLACE TABLE FINSERV_HOL_DB.RISK.COMPLIANCE_ALERTS (
  ALERT_ID INTEGER,
  ACCOUNT_ID INTEGER,
  ALERT_TYPE VARCHAR(50),
  SEVERITY VARCHAR(10),
  DESCRIPTION VARCHAR(300),
  CREATED_DATE DATE,
  STATUS VARCHAR(20),
  RESOLVED_DATE DATE
);

INSERT INTO FINSERV_HOL_DB.RISK.COMPLIANCE_ALERTS VALUES
(1, 1, 'Concentration Risk', 'High', 'Single position (AAPL) exceeds 40% of portfolio value', '2025-04-20', 'Open', NULL),
(2, 8, 'Concentration Risk', 'Critical', 'Single position (NVDA) exceeds 49% of portfolio value', '2025-04-20', 'Open', NULL),
(3, 11, 'Concentration Risk', 'High', 'Single position (NVDA) exceeds 41% of portfolio value', '2025-04-20', 'Open', NULL),
(4, 18, 'Sector Concentration', 'High', 'Technology sector exposure exceeds 70% of portfolio', '2025-04-15', 'Open', NULL),
(5, 5, 'Sector Concentration', 'Medium', 'Technology sector exposure exceeds 50% of portfolio', '2025-04-10', 'Open', NULL),
(6, 1, 'Risk Tolerance Drift', 'Medium', 'Portfolio risk score (0.82) exceeds aggressive threshold by margin', '2025-04-20', 'Open', NULL),
(7, 8, 'Risk Tolerance Drift', 'High', 'Portfolio risk score (0.88) significantly exceeds aggressive threshold', '2025-04-20', 'Open', NULL),
(8, 15, 'Duration Risk', 'Medium', 'Bond portfolio duration exceeds target by 2+ years', '2025-03-15', 'Open', NULL),
(9, 9, 'Rebalancing Due', 'Low', 'Portfolio has not been rebalanced in 6+ months', '2025-04-01', 'Open', NULL),
(10, 22, 'Rebalancing Due', 'Low', 'Portfolio has not been rebalanced in 6+ months', '2025-04-05', 'Open', NULL),
(11, 4, 'Wash Sale', 'Medium', 'Potential wash sale detected on GOOGL position', '2025-02-12', 'Resolved', '2025-02-20'),
(12, 7, 'Large Transaction', 'Low', 'Single transaction exceeds $200K threshold', '2025-02-01', 'Resolved', '2025-02-03'),
(13, 18, 'Large Transaction', 'Low', 'Single transaction exceeds $2M threshold', '2025-03-10', 'Resolved', '2025-03-12'),
(14, 3, 'Suitability', 'Medium', 'Conservative client holds 0% equity allocation - review needed', '2025-04-12', 'Open', NULL),
(15, 6, 'Low Diversification', 'Medium', 'Portfolio has fewer than 5 distinct holdings', '2025-04-15', 'Open', NULL);

CREATE OR REPLACE TABLE FINSERV_HOL_DB.PORTFOLIO.BENCHMARKS (
  BENCHMARK_ID INTEGER,
  BENCHMARK_NAME VARCHAR(100),
  ASSET_CLASS VARCHAR(30),
  YTD_RETURN NUMBER(6,2),
  ONE_YEAR_RETURN NUMBER(6,2),
  THREE_YEAR_RETURN NUMBER(6,2),
  FIVE_YEAR_RETURN NUMBER(6,2),
  AS_OF_DATE DATE
);

INSERT INTO FINSERV_HOL_DB.PORTFOLIO.BENCHMARKS VALUES
(1, 'S&P 500', 'Equity', 8.20, 22.50, 10.80, 14.20, '2025-04-20'),
(2, 'Bloomberg US Aggregate Bond', 'Fixed Income', 1.80, 4.50, -1.20, 0.80, '2025-04-20'),
(3, 'MSCI EAFE', 'International Equity', 6.50, 15.20, 5.80, 7.50, '2025-04-20'),
(4, 'Russell 2000', 'Small Cap Equity', 3.80, 18.90, 2.50, 9.80, '2025-04-20'),
(5, 'MSCI Emerging Markets', 'Emerging Markets', 5.20, 12.80, 1.50, 4.20, '2025-04-20'),
(6, 'Bloomberg US High Yield', 'High Yield', 3.50, 8.20, 3.80, 5.10, '2025-04-20'),
(7, 'FTSE NAREIT All REITs', 'Real Estate', 2.80, 10.50, -0.50, 5.80, '2025-04-20'),
(8, 'Gold Spot', 'Commodities', 12.50, 28.00, 8.50, 10.20, '2025-04-20');

GRANT ALL ON ALL TABLES IN SCHEMA FINSERV_HOL_DB.PORTFOLIO TO ROLE FINSERV_HOL_ROLE;
GRANT ALL ON ALL TABLES IN SCHEMA FINSERV_HOL_DB.RISK TO ROLE FINSERV_HOL_ROLE;
GRANT ALL ON ALL STAGES IN SCHEMA FINSERV_HOL_DB.PORTFOLIO TO ROLE FINSERV_HOL_ROLE;
