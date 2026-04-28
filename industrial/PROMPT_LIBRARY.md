# Industrial / Manufacturing Track -- Prompt Library

All prompts are copy-paste ready. Each has a primary version and a fallback.

---

## Step 1: Database Setup

### 1.1 Primary Prompt
```
Please execute the setup script from the GitHub repository we connected.
Run this file to create the industrial operations database, warehouse,
all tables, internal stages, and load all sample data:

@HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/industrial/scripts/setup.sql

Use EXECUTE IMMEDIATE FROM to run it. After execution, give me a brief
summary of what was created.
```

### 1.1 Fallback Prompt
```
Please read the contents of the file at this Git stage path and execute
it as a SQL script, running each statement sequentially:

@HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/industrial/scripts/setup.sql

Break it into logical sections and show me progress after each section.
```

### 1.2 Inspect Prompt
```
Show me all the tables in INDUSTRIAL_HOL_DB.OPERATIONS and
INDUSTRIAL_HOL_DB.ENERGY with their row counts. Display as a
clean summary table.
```

---

## Step 2: Semantic Models

### 2.1 Primary Prompt
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

### 2.1 Fallback Prompt
```
Copy the pre-built equipment analytics semantic model from GitHub:

Source: @HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/industrial/scripts/semantic_models/EQUIPMENT_ANALYTICS_MODEL.yaml
Destination: @INDUSTRIAL_HOL_DB.OPERATIONS.SEMANTIC_MODELS_STAGE

Use COPY FILES INTO to transfer it.
```

### 2.2 Energy Model
```
Set up Cortex Analyst for energy data using the pre-built YAML model in
our GitHub repository at:

@HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/industrial/scripts/semantic_models/ENERGY_CONSUMPTION_MODEL.yaml

Note: the YAML file can't be read directly from the Git stage. Instead,
read the file contents from the stage and use
SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML to register it as a semantic view
in INDUSTRIAL_HOL_DB.OPERATIONS.
```

### 2.3 Inspect -- Snowsight UI
Guide attendees to AI & ML > Analyst to test EQUIPMENT_ANALYTICS.

---

## Step 3: Cortex Search

### 3.1 Bring PDF into Snowflake
```
Bring the following PDF from our GitHub repository into
INDUSTRIAL_HOL_DB.OPERATIONS so we can make it searchable:

@HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/industrial/pdfs/Maintenance Operations Guide.pdf
```

### 3.2 Primary Prompt
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

### 3.3 Test Search -- Snowsight UI
Guide attendees to AI & ML > Search to test MAINTENANCE_DOCS_INFO.

---

## Step 4: Intelligence Agent

### 4.1 Primary Prompt
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

### 4.2/4.3 -- Snowsight UI
Test in AI & ML > Agents > INDUSTRIAL_AGENT Playground.

---

## Step 5: Streamlit App

### 5.1 Chat Page
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

### 5.2 Dashboard Page
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
- A bar chart comparing budgeted vs actual energy consumption by facility

BOTTOM ROW - a critical alerts table:
- All equipment where NEXT_SERVICE_DATE < CURRENT_DATE, showing:
  Equipment Name, Facility, Criticality, Days Overdue, Last Service Date,
  Replacement Cost
- Sort by criticality then days overdue
- Include a button to download the table as a CSV
```

### 5.3 Optimization Page
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
