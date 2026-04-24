# Financial Services Track -- Steps 1 through 5

> **Prerequisites:** Complete [Step 0](../shared/LAB_GUIDE.md) first (login, Cortex Code, GitHub setup).

---

## Step 1: Build the Database and Load Data (10 minutes)

In this step, you'll create a financial services database with clients, portfolios, holdings, risk scores, and compliance alerts -- all by asking Cortex Code to run a single script directly from GitHub.

### 1.1 Execute the Setup Script

```
Please execute the setup script from the GitHub repository we connected.
Run this file to create the financial services database, warehouse, all
tables, internal stages, and load all sample data:

@HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/financial-services/scripts/setup.sql

Use EXECUTE IMMEDIATE FROM to run it. After execution, give me a brief
summary of what was created.
```

> **What's happening:** The script creates:
> - Database: `FINSERV_HOL_DB` with schemas `PORTFOLIO` and `RISK`
> - Warehouse: `FINSERV_HOL_WH`
> - 9 tables with realistic financial data (clients, accounts, holdings, transactions, risk scores, compliance alerts, benchmarks)
> - Internal stages for files you'll use later

### 1.2 Inspect What Was Built

```
Show me all the tables in FINSERV_HOL_DB.PORTFOLIO and
FINSERV_HOL_DB.RISK with their row counts. Display as a
clean summary table.
```

**Expected output:**

| Schema | Table | Row Count |
|--------|-------|-----------|
| PORTFOLIO | ADVISORS | 8 |
| PORTFOLIO | CLIENTS | 25 |
| PORTFOLIO | ACCOUNTS | 26 |
| PORTFOLIO | SECURITIES | 20 |
| PORTFOLIO | HOLDINGS | 30 |
| PORTFOLIO | TRANSACTIONS | 25 |
| PORTFOLIO | BENCHMARKS | 8 |
| RISK | RISK_SCORES | 26 |
| RISK | COMPLIANCE_ALERTS | 15 |

---

## Step 2: Create the Semantic Layer (12 minutes)

Cortex Analyst is Snowflake's text-to-SQL engine. Define your business metrics once -- then anyone can query portfolio data in plain English.

### 2.1 Set Up Cortex Analyst for Portfolio Data

```
Set up Cortex Analyst for the portfolio data in FINSERV_HOL_DB.PORTFOLIO.

Include these tables: ADVISORS, CLIENTS, ACCOUNTS, SECURITIES, HOLDINGS,
TRANSACTIONS, and BENCHMARKS.

Business intelligence rules:
- Flag "concentrated position" when POSITION_PCT > 15
- Flag "high risk" when RISK_SCORE > 0.8 (from FINSERV_HOL_DB.RISK.RISK_SCORES)

Make sure it can answer questions like:
1. "What is the total AUM by advisor?"
2. "Which accounts have concentrated positions above 15%?"
3. "Show me the top 10 holdings by unrealized P&L"
4. "What is the YTD performance vs S&P 500 benchmark?"

Name the model PORTFOLIO_ANALYTICS and store it in FINSERV_HOL_DB.PORTFOLIO.
```

### 2.2 Add Risk Analytics to Cortex Analyst

```
Set up Cortex Analyst for risk data using the pre-built YAML model in
our GitHub repository at:

@HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/financial-services/scripts/semantic_models/MARKET_RISK_MODEL.yaml

Note: the YAML file can't be read directly from the Git stage. Instead,
read the file contents from the stage and use
SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML to register it as a semantic view
in FINSERV_HOL_DB.PORTFOLIO.
```

### 2.3 Explore Your Semantic Model in Snowsight

1. In the left navigation, click **AI & ML**
2. Click **Analyst**
3. Find your **PORTFOLIO_ANALYTICS** semantic view
4. Try: *"What is the total AUM by advisor region?"*
5. Try: *"Which clients have the highest unrealized gains?"*

---

## Step 3: Set Up Document Search (8 minutes)

### 3.1 Bring the PDF into Snowflake

```
Bring the following PDF from our GitHub repository into
FINSERV_HOL_DB.PORTFOLIO so we can make it searchable:

@HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/financial-services/pdfs/Risk Management Framework.pdf
```

### 3.2 Create the Search Service

```
Create a Cortex Search service called RISK_DOCS_INFO in
FINSERV_HOL_DB.PORTFOLIO that makes the risk management PDF
searchable with natural language.

To do this:
- Temporarily scale up FINSERV_HOL_WH for processing power
- Read and parse the PDF content
- Break it into overlapping chunks for better search accuracy
- Index everything so it can be queried in plain English
- Scale the warehouse back down to SMALL when done
```

### 3.3 Explore Your Search Service in Snowsight

1. Click **AI & ML** > **Search**
2. Find **RISK_DOCS_INFO** and try: *"portfolio rebalancing triggers"*
3. Try: *"maximum position concentration limits"*

---

## Step 4: Build the Intelligence Agent (10 minutes)

### 4.1 Create the Agent

```
Create a Snowflake Intelligence Agent named FINSERV_AGENT in
FINSERV_HOL_DB.PORTFOLIO.

Give it three tools:

1. A data analysis tool named PORTFOLIO_DATA connected to the
   PORTFOLIO_ANALYTICS semantic model in FINSERV_HOL_DB.PORTFOLIO.
   It answers questions about clients, accounts, holdings,
   transactions, and performance. Use FINSERV_HOL_WH.

2. A data analysis tool named RISK_DATA connected to the
   MARKET_RISK semantic model in FINSERV_HOL_DB.PORTFOLIO.
   It analyzes risk scores, compliance alerts, and portfolio
   risk metrics. Use FINSERV_HOL_WH.

3. A document search tool named RISK_DOCS connected to the
   RISK_DOCS_INFO search service in FINSERV_HOL_DB.PORTFOLIO.
   It searches risk management documentation for policies
   and compliance rules.
```

### 4.2 Peek at What You Built (Snowsight UI)

1. **AI & ML** > **Agents** > **FINSERV_AGENT**
2. Open the **Tools** tab to see all 3 tools

### 4.3 Test the Agent in Snowflake Intelligence

Click **Playground** and try:

**Question 1 -- Portfolio Analysis:**
> Which accounts have concentrated positions above 15%?

**Question 2 -- Risk Assessment:**
> Show me all open compliance alerts sorted by severity, and which advisor manages each flagged account.

**Question 3 -- Market Risk:**
> What is the total Value at Risk across all high-risk accounts?

**Question 4 -- Policy Lookup:**
> What does our risk management framework say about rebalancing trigger thresholds?

---

## Step 5: Build a Streamlit App (25 minutes)

### 5.1 Create the Chat Page (8 minutes)

```
Build a 3-page Streamlit app in Snowflake called FINSERV_ASSISTANT_APP
in FINSERV_HOL_DB.PORTFOLIO using FINSERV_HOL_WH.

Start with page 1 -- "Chat" (the home page):
- A sidebar with the title "Financial Services Assistant" and a brief description
- A conversational chat interface connected to FINSERV_AGENT
- Stream the agent's responses in real time as they arrive
- When the agent returns data, display it as a table
- When the agent returns SQL, show it in a collapsible section
- Keep the full conversation history visible as users scroll
- Use claude-3-5-sonnet as the model
```

### 5.2 Open and Test the Chat Page

1. Navigate to Apps > FINSERV_ASSISTANT_APP
2. Try: **"Which clients have the highest unrealized gains?"**

### 5.3 Add the Dashboard Page (10 minutes)

```
Add a second page to FINSERV_ASSISTANT_APP called "Dashboard".

This page should show live data from FINSERV_HOL_DB:

TOP ROW - four summary numbers:
- Total AUM (sum of all account balances)
- Active Clients (count from CLIENTS where STATUS = 'Active')
- Open Compliance Alerts (from RISK.COMPLIANCE_ALERTS where STATUS = 'Open')
- Average Portfolio Risk Score (from RISK.RISK_SCORES)

MIDDLE ROW - two charts side by side:
- A bar chart of AUM by advisor, showing each advisor's total
  assets under management
- A pie chart of holdings by asset class (Equity, Fixed Income,
  Alternative)

BOTTOM ROW - a compliance alerts table:
- All open alerts showing: Account Name, Client Name, Alert Type,
  Severity, Description, Days Open
- Sort by severity (Critical > High > Medium > Low)
- Include a button to download the table as a CSV
```

### 5.4 Add the Optimization Page (7 minutes)

```
Add a third page to FINSERV_ASSISTANT_APP called "Optimization".

Title: "Portfolio Rebalancing Optimizer"
Subtitle: "Identify concentrated positions and generate trade
recommendations to bring portfolios back within risk limits."

Include a "Run Optimization" button that when clicked:
1. Finds all holdings where POSITION_PCT > 15 (concentrated positions)
2. Calculates the target allocation to reduce concentration below 15%
3. Identifies which securities to sell (reduce concentrated ones) and
   which to buy (increase diversification based on client risk tolerance)
4. Uses linear programming to minimize trading costs while meeting
   all concentration and risk constraints

Show the results as:
- A headline number: how many accounts need rebalancing and total
  notional trade value
- A table of recommended sells: Account, Security, Current %, Target %,
  Shares to Sell, Estimated Proceeds
- A table of recommended buys: Account, Security, Shares to Buy,
  Estimated Cost, Rationale
- A before/after bar chart showing position concentration per account

Add scipy to the app's dependencies.
```

### 5.5 Test Your Complete App

1. **Chat** -- Ask "What is the total AUM by region?"
2. **Dashboard** -- Review compliance alerts and AUM distribution
3. **Optimization** -- Click "Run Optimization" and see rebalancing recommendations

> **Congratulations!** You've built a complete AI-powered financial services application -- all by talking to Cortex Code.
