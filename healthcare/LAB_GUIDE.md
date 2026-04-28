# Healthcare Track -- Cortex Code Hands-On Lab

## Powered by Cortex Code

---

### About This Lab

In this hands-on lab, you will build a fully functional AI-powered Healthcare Assistant using **only natural language prompts** in Snowflake's Cortex Code IDE. No SQL writing, no YAML editing, no manual UI configuration -- you'll talk to Cortex Code and it will build everything for you.

**What you'll build:**
- A clinical database with patient records, encounters, lab results, and more
- Semantic models that let anyone query clinical data in plain English
- A search engine over clinical documentation
- A Snowflake Intelligence Agent that routes questions to the right data source
- A multi-page Streamlit app with chat, dashboards, and bed optimization

**Time:** 75 minutes hands-on
**Prerequisites:** A laptop with a modern browser. No coding experience required. No files to download -- everything comes directly from GitHub.

---

## Step 0: Get Started (8 minutes)

### 0.1 Log Into Your Snowflake Trial Account

Your instructor will provide you with trial account credentials. Open your browser and navigate to the Snowflake login URL provided.

1. Enter your **username** and **password**
2. You should land on the Snowsight home page

### 0.2 Open Cortex Code

1. In the left navigation bar, click **Projects**
2. Click **Cortex Code**
3. You should see the Cortex Code IDE with a chat panel on the right

> **What is Cortex Code?** Cortex Code is Snowflake's AI-powered IDE. You can ask it to write SQL, create objects, build applications, and more -- all through natural language conversation. Think of it as your AI pair programmer that understands Snowflake natively.

### 0.3 Connect to the Lab's GitHub Repository

Instead of downloading any files, you'll connect Snowflake directly to the public GitHub repository that contains all the lab materials. Snowflake can read and execute files straight from GitHub -- no ZIP files, no uploads.

Copy and paste this prompt into Cortex Code:

```
Please connect my Snowflake account to a public GitHub repository so I can
use it as a file source during this lab.

1. Create a database called HOL_UTILS with schema PUBLIC if it doesn't exist
2. Create an API integration called HOL_GITHUB_API for GitHub HTTPS access,
   allowing the prefix https://github.com/jfromkamel/
3. Create a Git repository object called SNOWFLAKE_AI_HOL_REPO in the
   HOL_UTILS.PUBLIC schema pointing to:
   https://github.com/jfromkamel/snowflake-ai-hol
4. Fetch the latest contents from the repository
5. Confirm everything worked by listing the top-level files and folders
   available in the main branch
```

> **What's happening:** Cortex Code is creating a live connection between your Snowflake account and the lab's GitHub repository. All scripts, models, and documents will be accessible directly from GitHub -- no manual file handling needed.

**Expected output:** You should see a folder listing including `healthcare/`, `financial-services/`, `industrial/`, and `README.md`.

> **Note:** This is the only prompt in the lab that requires ACCOUNTADMIN. Cortex Code will handle the role switching automatically.

### Fallback SQL for Step 0.3

If Cortex Code can't handle the Git setup, run this SQL directly in a Snowsight worksheet:

```sql
USE ROLE ACCOUNTADMIN;
CREATE DATABASE IF NOT EXISTS HOL_UTILS;
CREATE SCHEMA IF NOT EXISTS HOL_UTILS.PUBLIC;
CREATE OR REPLACE API INTEGRATION HOL_GITHUB_API
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/jfromkamel/')
  ENABLED = TRUE;
CREATE OR REPLACE GIT REPOSITORY HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO
  API_INTEGRATION = HOL_GITHUB_API
  ORIGIN = 'https://github.com/jfromkamel/snowflake-ai-hol';
ALTER GIT REPOSITORY HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO FETCH;
LS @HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/;
```

---

## Step 1: Build the Database and Load Data (10 minutes)

In this step, you'll create a healthcare database with patient records, encounters, diagnoses, lab results, and more -- all by asking Cortex Code to run a single script directly from GitHub.

### 1.1 Execute the Setup Script

```
Please execute the setup script from the GitHub repository we connected.
Run this file to create the healthcare database, warehouse, all tables,
internal stages, and load all sample data:

@HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/healthcare/scripts/setup.sql

Use EXECUTE IMMEDIATE FROM to run it. After execution, give me a brief
summary of what was created.
```

> **What's happening:** Cortex Code is pulling the setup script directly from GitHub and executing it. The script creates:
> - Database: `HEALTHCARE_HOL_DB` with schemas `CLINICAL` and `OPERATIONS`
> - Warehouse: `HEALTHCARE_HOL_WH`
> - 11 tables with realistic patient, provider, and operational data
> - Internal stages for files you'll use later

### 1.2 Inspect What Was Built

```
Show me all the tables in HEALTHCARE_HOL_DB.CLINICAL and
HEALTHCARE_HOL_DB.OPERATIONS with their row counts. Display as a
clean summary table.
```

**Expected output:**

| Schema | Table | Row Count |
|--------|-------|-----------|
| CLINICAL | PATIENTS | 50 |
| CLINICAL | PROVIDERS | 25 |
| CLINICAL | DEPARTMENTS | 8 |
| CLINICAL | ENCOUNTERS | 60 |
| CLINICAL | DIAGNOSES | 66 |
| CLINICAL | PROCEDURES | 30 |
| CLINICAL | MEDICATIONS | 32 |
| CLINICAL | LAB_RESULTS | 55 |
| CLINICAL | BEDS | 44 |
| CLINICAL | READMISSIONS | 20 |
| OPERATIONS | INSURANCE_CLAIMS | 40 |

> **Congratulations!** You just built an entire clinical database without writing a single line of SQL.

---

## Step 2: Create the Semantic Layer (12 minutes)

Cortex Analyst is Snowflake's text-to-SQL engine. You define your business metrics, table relationships, and business rules once -- then anyone can query your data in plain English without knowing SQL.

In this step, you'll have Cortex Code **set up Cortex Analyst** from scratch.

### 2.1 Set Up Cortex Analyst for Clinical Data

This is the "wow" moment. Copy and paste this prompt:

```
Set up Cortex Analyst for the clinical data in HEALTHCARE_HOL_DB.CLINICAL.

Include these tables: PATIENTS, PROVIDERS, DEPARTMENTS, ENCOUNTERS,
DIAGNOSES, PROCEDURES, MEDICATIONS, LAB_RESULTS, BEDS, and READMISSIONS.

Business intelligence rules:
- Flag "high readmission risk" when RISK_SCORE > 0.7
- Flag "extended stay" when LENGTH_OF_STAY > 7
- Flag "critical lab" when RESULT_FLAG = 'Critical'

Make sure it can answer questions like:
1. "How many patients are currently admitted?"
2. "What is the average length of stay by department?"
3. "Which patients are at high risk for readmission?"
4. "Show me all critical lab results"

Name the model PATIENT_CARE and store it in HEALTHCARE_HOL_DB.CLINICAL.
```

> **What's happening:** Cortex Code is analyzing your table structures, understanding the clinical relationships, and configuring a complete text-to-SQL layer. This would normally take a data engineer hours to write manually.

### 2.2 Add Insurance Claims to Cortex Analyst

```
Set up Cortex Analyst for insurance claims data using the pre-built YAML
model in our GitHub repository at:

@HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/healthcare/scripts/semantic_models/CLAIMS_ANALYTICS_MODEL.yaml

Note: the YAML file can't be read directly from the Git stage. Instead,
read the file contents from the stage and use
SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML to register it as a semantic view
in HEALTHCARE_HOL_DB.CLINICAL.
```

### 2.3 Explore Your Semantic Model in Snowsight

Let's step out of Cortex Code and see what you built in the Snowsight UI.

1. In the left navigation, click **AI & ML**
2. Click **Analyst**
3. You should see your **PATIENT_CARE** semantic view listed
4. Click on it to open the Analyst chat interface
5. Try asking:
   - *"How many patients are currently admitted by department?"*
   - *"What is the average length of stay for cardiology patients?"*
6. Click the **SQL** toggle to see the generated query behind the scenes

> **Key takeaway:** Anyone in your organization can now query clinical data in plain English -- no SQL required.

---

## Step 3: Set Up Document Search (8 minutes)

In this step, you'll create a search engine over clinical documentation so the agent can answer questions about protocols, policies, and procedures.

### 3.1 Bring the PDF into Snowflake

```
Bring the following PDF from our GitHub repository into
HEALTHCARE_HOL_DB.CLINICAL so we can make it searchable:

@HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/healthcare/pdfs/Clinical Operations Manual.pdf
```

### 3.2 Create the Search Service

```
Create a Cortex Search service called CLINICAL_DOCS_INFO in
HEALTHCARE_HOL_DB.CLINICAL that makes the clinical operations PDF
searchable with natural language.

To do this:
- Temporarily scale up HEALTHCARE_HOL_WH for processing power
- Read and parse the PDF content
- Break it into overlapping chunks for better search accuracy
- Index everything so it can be queried in plain English
- Scale the warehouse back down to SMALL when done
```

### 3.3 Explore Your Search Service in Snowsight

1. In the left navigation, click **AI & ML**
2. Click **Search**
3. Find your **CLINICAL_DOCS_INFO** service and click on it
4. Try: *"discharge planning procedures"*
5. Try: *"triage protocol for chest pain"*

> **Key takeaway:** You now have a search engine over your clinical documentation that understands meaning, not just keywords.

---

## Step 4: Build the Intelligence Agent (10 minutes)

Now you'll wire everything together into a single AI agent that automatically routes questions to the right data source.

### 4.1 Create the Agent

```
Create a Snowflake Intelligence Agent named HEALTHCARE_AGENT in
HEALTHCARE_HOL_DB.CLINICAL.

Give it three tools:

1. A data analysis tool named PATIENT_CARE_DATA connected to the
   PATIENT_CARE semantic model in HEALTHCARE_HOL_DB.CLINICAL.
   It answers questions about patients, encounters, diagnoses,
   labs, and bed management. Use HEALTHCARE_HOL_WH.

2. A data analysis tool named CLAIMS_DATA connected to the
   CLAIMS_ANALYTICS semantic model in HEALTHCARE_HOL_DB.CLINICAL.
   It analyzes insurance claims, approval rates, and billing data.
   Use HEALTHCARE_HOL_WH.

3. A document search tool named CLINICAL_DOCS connected to the
   CLINICAL_DOCS_INFO search service in HEALTHCARE_HOL_DB.CLINICAL.
   It searches clinical documentation for protocols and procedures.
```

### 4.2 Peek at What You Built (Snowsight UI)

1. In the left navigation, click **AI & ML**
2. Click **Agents** (under Snowflake Intelligence)
3. Find your **HEALTHCARE_AGENT** and click on it
4. Open the **Tools** tab -- you'll see all 3 tools configured

### 4.3 Test the Agent in Snowflake Intelligence

Stay in the Snowflake Intelligence UI. Click **Playground** and try these questions:

**Question 1 -- Patient Analysis (routes to clinical data):**
> Which patients are at high risk for readmission?

**Question 2 -- Operational Analysis (complex multi-table query):**
> For departments with the highest average length of stay, show me the most common diagnoses and the bed occupancy rate.

**Question 3 -- Claims Analysis (routes to claims data):**
> What is the approval rate by insurance type, and which claims were denied?

**Question 4 -- Policy Lookup (routes to document search):**
> What does our documentation say about discharge planning procedures?

> **Key takeaway:** The agent automatically picks the right tool for each question. One interface, every data source, no SQL required.

---

## Step 5: Build a Streamlit App (25 minutes)

You'll build a multi-page Streamlit application with chat, dashboards, and a bed optimization engine.

### 5.1 Create the Chat Page (8 minutes)

```
Build a 3-page Streamlit app in Snowflake called HEALTHCARE_ASSISTANT_APP
in HEALTHCARE_HOL_DB.CLINICAL using HEALTHCARE_HOL_WH.

Start with page 1 -- "Chat" (the home page):
- A sidebar with the title "Healthcare Assistant" and a brief description
- A conversational chat interface connected to HEALTHCARE_AGENT
- Stream the agent's responses in real time as they arrive
- When the agent returns data, display it as a table
- When the agent returns SQL, show it in a collapsible section
- Keep the full conversation history visible as users scroll
- Use claude-3-5-sonnet as the model
```

### 5.2 Open and Test the Chat Page

1. Navigate to the app in Snowsight (Apps > HEALTHCARE_ASSISTANT_APP)
2. Try asking: **"Which patients are currently admitted to the ICU?"**
3. Watch the agent respond through your app!

### 5.3 Add the Dashboard Page (10 minutes)

```
Add a second page to HEALTHCARE_ASSISTANT_APP called "Dashboard".

This page should show live data from HEALTHCARE_HOL_DB.CLINICAL:

TOP ROW - four summary numbers:
- Total Admitted Patients (PATIENTS where STATUS = 'Admitted')
- Bed Occupancy Rate (occupied beds / total beds as percentage)
- Average Length of Stay (from ENCOUNTERS)
- High Readmission Risk Patients (READMISSIONS where RISK_SCORE > 0.7)

MIDDLE ROW - two charts side by side:
- A bar chart of bed occupancy by department, highlighting departments
  above 80% occupancy
- A pie chart of encounters by type (Inpatient/Outpatient/Emergency)

BOTTOM ROW - a critical alerts table:
- All patients with RISK_SCORE > 0.7, showing: Patient Name,
  Department, Primary Diagnosis, Risk Score, Days Since Last Discharge,
  Readmission Reason
- Sort by risk score descending (highest risk first)
- Include a button to download the table as a CSV
```

### 5.4 Add the Optimization Page (7 minutes)

```
Add a third page to HEALTHCARE_ASSISTANT_APP called "Optimization".

Title: "Bed Allocation Optimizer"
Subtitle: "Find the best way to manage bed assignments across departments
based on current occupancy, patient acuity, and upcoming discharges."

Include a "Run Optimization" button that when clicked:
1. Finds departments with occupancy above 80%
2. Finds departments with available beds
3. Identifies patients nearing discharge (admitted > 5 days with
   completed status encounters)
4. Uses linear programming to suggest patient transfers that balance
   occupancy across departments while keeping patients in appropriate
   bed types

Show the results as:
- A headline number: how many beds freed up and departments rebalanced
- A table of recommended patient moves: Patient, From Department,
  To Department, Bed Type, Reason
- A before/after bar chart comparing department occupancy

Add scipy to the app's dependencies.
```

### 5.5 Test Your Complete App

1. **Chat** -- Ask "What are the most common diagnoses this month?"
2. **Dashboard** -- Review occupancy rates and readmission risk alerts
3. **Optimization** -- Click "Run Optimization" and see bed rebalancing recommendations

> **Congratulations!** You've built a complete AI-powered healthcare application -- clinical database, semantic layer, document search, intelligent agent, and a polished UI -- all by talking to Cortex Code.
