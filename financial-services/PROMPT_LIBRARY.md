# Financial Services Track -- Prompt Library

All prompts are copy-paste ready. Each has a primary version and a fallback.

---

## Step 1: Database Setup

### 1.1 Primary Prompt
```
Please execute the setup script from the GitHub repository we connected.
Run this file to create the financial services database, warehouse, all
tables, internal stages, and load all sample data:

@HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/financial-services/scripts/setup.sql

Use EXECUTE IMMEDIATE FROM to run it. After execution, give me a brief
summary of what was created.
```

### 1.1 Fallback Prompt
```
Please read the contents of the file at this Git stage path and execute
it as a SQL script, running each statement sequentially:

@HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/financial-services/scripts/setup.sql

Break it into logical sections and show me progress after each section.
```

### 1.2 Inspect Prompt
```
Show me all the tables in FINSERV_HOL_DB.PORTFOLIO and
FINSERV_HOL_DB.RISK with their row counts. Display as a clean summary table.
```

---

## Step 2: Semantic Models

### 2.1 Primary Prompt
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

### 2.1 Fallback Prompt
```
Copy the pre-built portfolio analytics semantic model from the GitHub
repository into the semantic models stage:

Source: @HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/financial-services/scripts/semantic_models/PORTFOLIO_ANALYTICS_MODEL.yaml
Destination: @FINSERV_HOL_DB.PORTFOLIO.SEMANTIC_MODELS_STAGE

Use COPY FILES INTO to transfer it.
```

### 2.2 Risk Model
```
Set up Cortex Analyst for risk data using the pre-built YAML model in
our GitHub repository at:

@HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/financial-services/scripts/semantic_models/MARKET_RISK_MODEL.yaml

Note: the YAML file can't be read directly from the Git stage. Instead,
read the file contents from the stage and use
SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML to register it as a semantic view
in FINSERV_HOL_DB.PORTFOLIO.
```

### 2.3 Inspect -- Snowsight UI
Guide attendees to AI & ML > Analyst to test PORTFOLIO_ANALYTICS.

---

## Step 3: Cortex Search

### 3.1 Bring PDF into Snowflake
```
Bring the following PDF from our GitHub repository into
FINSERV_HOL_DB.PORTFOLIO so we can make it searchable:

@HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/financial-services/pdfs/Risk Management Framework.pdf
```

### 3.2 Primary Prompt
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

### 3.3 Test Search -- Snowsight UI
Guide attendees to AI & ML > Search to test RISK_DOCS_INFO.

---

## Step 4: Intelligence Agent

### 4.1 Primary Prompt
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

### 4.2/4.3 -- Snowsight UI
Test in AI & ML > Agents > FINSERV_AGENT Playground.

---

## Step 5: Streamlit App

### 5.1 Chat Page
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

### 5.2 Dashboard Page
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

### 5.3 Optimization Page
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
