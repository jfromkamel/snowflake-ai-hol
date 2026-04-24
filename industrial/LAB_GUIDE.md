# Industrial / Manufacturing Track -- Steps 1 through 5

> **Prerequisites:** Complete [Step 0](../shared/LAB_GUIDE.md) first (login, Cortex Code, GitHub setup).

---

## Step 1: Build the Database and Load Data (10 minutes)

In this step, you'll create an industrial operations database with equipment records, work orders, maintenance logs, downtime events, and energy data -- all by asking Cortex Code to run a single script directly from GitHub.

### 1.1 Execute the Setup Script

```
Please execute the setup script from the GitHub repository we connected.
Run this file to create the industrial operations database, warehouse,
all tables, internal stages, and load all sample data:

@HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/industrial/scripts/setup.sql

Use EXECUTE IMMEDIATE FROM to run it. After execution, give me a brief
summary of what was created.
```

> **What's happening:** The script creates:
> - Database: `INDUSTRIAL_HOL_DB` with schemas `OPERATIONS` and `ENERGY`
> - Warehouse: `INDUSTRIAL_HOL_WH`
> - 10 tables with realistic maintenance, production, and energy data
> - Internal stages for files you'll use later

### 1.2 Inspect What Was Built

```
Show me all the tables in INDUSTRIAL_HOL_DB.OPERATIONS and
INDUSTRIAL_HOL_DB.ENERGY with their row counts. Display as a
clean summary table.
```

**Expected output:**

| Schema | Table | Row Count |
|--------|-------|-----------|
| OPERATIONS | FACILITIES | 6 |
| OPERATIONS | PRODUCTION_LINES | 12 |
| OPERATIONS | TECHNICIANS | 20 |
| OPERATIONS | EQUIPMENT | 35 |
| OPERATIONS | WORK_ORDERS | 28 |
| OPERATIONS | DOWNTIME_EVENTS | 15 |
| OPERATIONS | SPARE_PARTS | 20 |
| OPERATIONS | MAINTENANCE_LOGS | 17 |
| OPERATIONS | QUALITY_INSPECTIONS | 20 |
| ENERGY | ENERGY_METERS | 25 |

---

## Step 2: Create the Semantic Layer (12 minutes)

Cortex Analyst is Snowflake's text-to-SQL engine. Define your business metrics once -- then anyone can query equipment and maintenance data in plain English.

### 2.1 Set Up Cortex Analyst for Equipment Analytics

```
Set up Cortex Analyst for the operations data in
INDUSTRIAL_HOL_DB.OPERATIONS.

Include these tables: FACILITIES, PRODUCTION_LINES, TECHNICIANS,
EQUIPMENT, WORK_ORDERS, DOWNTIME_EVENTS, SPARE_PARTS,
MAINTENANCE_LOGS, and QUALITY_INSPECTIONS.

Business intelligence rules:
- Flag "overdue maintenance" when NEXT_SERVICE_DATE < CURRENT_DATE
- Flag "critical equipment down" when STATUS = 'Overdue' and
  CRITICALITY = 'Critical'
- Flag "quality failure" when PASS_FAIL = 'Fail'

Make sure it can answer questions like:
1. "Which equipment is overdue for preventive maintenance?"
2. "What is the mean time to repair by facility?"
3. "Show me all unplanned downtime events this quarter"
4. "Which production lines have the highest defect rates?"

Name the model EQUIPMENT_ANALYTICS and store it in
INDUSTRIAL_HOL_DB.OPERATIONS.
```

### 2.2 Add Energy Analytics to Cortex Analyst

```
Set up Cortex Analyst for energy data using the pre-built YAML model in
our GitHub repository at:

@HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/industrial/scripts/semantic_models/ENERGY_CONSUMPTION_MODEL.yaml

Note: the YAML file can't be read directly from the Git stage. Instead,
read the file contents from the stage and use
SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML to register it as a semantic view
in INDUSTRIAL_HOL_DB.OPERATIONS.
```

### 2.3 Explore Your Semantic Model in Snowsight

1. In the left navigation, click **AI & ML**
2. Click **Analyst**
3. Find your **EQUIPMENT_ANALYTICS** semantic view
4. Try: *"Which equipment is overdue for maintenance?"*
5. Try: *"What was the total downtime cost by facility?"*

---

## Step 3: Set Up Document Search (8 minutes)

### 3.1 Bring the PDF into Snowflake

```
Bring the following PDF from our GitHub repository into
INDUSTRIAL_HOL_DB.OPERATIONS so we can make it searchable:

@HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/industrial/pdfs/Maintenance Operations Guide.pdf
```

### 3.2 Create the Search Service

```
Create a Cortex Search service called MAINTENANCE_DOCS_INFO in
INDUSTRIAL_HOL_DB.OPERATIONS that makes the maintenance operations PDF
searchable with natural language.

To do this:
- Temporarily scale up INDUSTRIAL_HOL_WH for processing power
- Read and parse the PDF content
- Break it into overlapping chunks for better search accuracy
- Index everything so it can be queried in plain English
- Scale the warehouse back down to SMALL when done
```

### 3.3 Explore Your Search Service in Snowsight

1. Click **AI & ML** > **Search**
2. Find **MAINTENANCE_DOCS_INFO** and try: *"emergency repair escalation procedures"*
3. Try: *"preventive maintenance scheduling policy"*

---

## Step 4: Build the Intelligence Agent (10 minutes)

### 4.1 Create the Agent

```
Create a Snowflake Intelligence Agent named INDUSTRIAL_AGENT in
INDUSTRIAL_HOL_DB.OPERATIONS.

Give it three tools:

1. A data analysis tool named EQUIPMENT_DATA connected to the
   EQUIPMENT_ANALYTICS semantic model in INDUSTRIAL_HOL_DB.OPERATIONS.
   It answers questions about equipment, maintenance, work orders,
   downtime, and quality. Use INDUSTRIAL_HOL_WH.

2. A data analysis tool named ENERGY_DATA connected to the
   ENERGY_CONSUMPTION semantic model in INDUSTRIAL_HOL_DB.OPERATIONS.
   It analyzes energy consumption, costs, and budget variances
   across facilities. Use INDUSTRIAL_HOL_WH.

3. A document search tool named MAINTENANCE_DOCS connected to the
   MAINTENANCE_DOCS_INFO search service in INDUSTRIAL_HOL_DB.OPERATIONS.
   It searches maintenance documentation for procedures and policies.
```

### 4.2 Peek at What You Built (Snowsight UI)

1. **AI & ML** > **Agents** > **INDUSTRIAL_AGENT**
2. Open the **Tools** tab to see all 3 tools

### 4.3 Test the Agent in Snowflake Intelligence

Click **Playground** and try:

**Question 1 -- Equipment Analysis:**
> Which equipment is overdue for preventive maintenance and what is its criticality?

**Question 2 -- Downtime Cost:**
> What was the total cost of unplanned downtime by facility this quarter, and what were the root causes?

**Question 3 -- Energy Analysis:**
> Which facilities are significantly over their energy budget, and by how much?

**Question 4 -- Policy Lookup:**
> What does our maintenance guide say about emergency repair escalation procedures?

---

## Step 5: Build a Streamlit App (25 minutes)

### 5.1 Create the Chat Page (8 minutes)

```
Build a 3-page Streamlit app in Snowflake called INDUSTRIAL_ASSISTANT_APP
in INDUSTRIAL_HOL_DB.OPERATIONS using INDUSTRIAL_HOL_WH.

Start with page 1 -- "Chat" (the home page):
- A sidebar with the title "Industrial Operations Assistant" and a brief description
- A conversational chat interface connected to INDUSTRIAL_AGENT
- Stream the agent's responses in real time as they arrive
- When the agent returns data, display it as a table
- When the agent returns SQL, show it in a collapsible section
- Keep the full conversation history visible as users scroll
- Use claude-3-5-sonnet as the model
```

### 5.2 Open and Test the Chat Page

1. Navigate to Apps > INDUSTRIAL_ASSISTANT_APP
2. Try: **"Which critical equipment has overdue maintenance?"**

### 5.3 Add the Dashboard Page (10 minutes)

```
Add a second page to INDUSTRIAL_ASSISTANT_APP called "Dashboard".

This page should show live data from INDUSTRIAL_HOL_DB:

TOP ROW - four summary numbers:
- Equipment Uptime Rate (operational equipment / total equipment as percentage)
- Open Work Orders (from WORK_ORDERS where STATUS in 'Overdue', 'Scheduled')
- Mean Time to Repair (average ACTUAL_HOURS from completed corrective work orders)
- Monthly Energy Cost (most recent month total from ENERGY.ENERGY_METERS)

MIDDLE ROW - two charts side by side:
- A bar chart of open work orders by facility, color-coded by priority
  (Critical, High, Medium, Low)
- A bar chart comparing budgeted vs actual energy consumption by facility
  for the most recent month

BOTTOM ROW - a critical alerts table:
- All equipment where NEXT_SERVICE_DATE < CURRENT_DATE, showing:
  Equipment Name, Facility, Criticality, Days Overdue, Last Service Date,
  Replacement Cost
- Sort by criticality (Critical first) then days overdue
- Include a button to download the table as a CSV
```

### 5.4 Add the Optimization Page (7 minutes)

```
Add a third page to INDUSTRIAL_ASSISTANT_APP called "Optimization".

Title: "Maintenance Scheduling Optimizer"
Subtitle: "Optimize the scheduling of overdue and upcoming maintenance
work to minimize downtime while respecting technician availability."

Include a "Run Optimization" button that when clicked:
1. Finds all overdue and upcoming (next 30 days) work orders
2. Gets technician availability by facility and specialization
3. Gets equipment criticality and estimated hours per work order
4. Uses linear programming to schedule work orders across available
   technicians, minimizing total downtime risk (weighted by equipment
   criticality and days overdue)
5. Respects constraints: technicians can only work on equipment at
   their facility, one job at a time, max 10 hours per day

Show the results as:
- A headline number: work orders scheduled and estimated days to
  clear the backlog
- A Gantt-style table: Technician, Equipment, Work Order, Scheduled Date,
  Estimated Hours, Priority
- A before/after comparison of overdue equipment count

Add scipy to the app's dependencies.
```

### 5.5 Test Your Complete App

1. **Chat** -- Ask "What were the most expensive downtime events this year?"
2. **Dashboard** -- Review equipment status and energy consumption
3. **Optimization** -- Click "Run Optimization" and see maintenance scheduling recommendations

> **Congratulations!** You've built a complete AI-powered industrial operations application -- all by talking to Cortex Code.
