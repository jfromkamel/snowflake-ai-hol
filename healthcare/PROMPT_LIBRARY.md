# Healthcare Track -- Prompt Library

All prompts are copy-paste ready. Each prompt has a primary version and a fallback.

---

## Step 1: Database Setup

### 1.1 Primary Prompt
```
Please execute the setup script from the GitHub repository we connected.
Run this file to create the healthcare database, warehouse, all tables,
internal stages, and load all sample data:

@HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/healthcare/scripts/setup.sql

Use EXECUTE IMMEDIATE FROM to run it. After execution, give me a brief
summary of what was created.
```

### 1.1 Fallback Prompt
```
Please read the contents of the file at this Git stage path and execute
it as a SQL script, running each statement sequentially:

@HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/healthcare/scripts/setup.sql

Break it into logical sections and show me progress after each section.
```

### 1.2 Inspect Prompt
```
Show me all the tables in HEALTHCARE_HOL_DB.CLINICAL and
HEALTHCARE_HOL_DB.OPERATIONS with their row counts. Display as a
clean summary table.
```

---

## Step 2: Semantic Models

### 2.1 Primary Prompt
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

### 2.1 Fallback Prompt
```
Copy the pre-built patient care semantic model from the GitHub repository
into the semantic models stage:

Source: @HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/healthcare/scripts/semantic_models/PATIENT_CARE_MODEL.yaml
Destination: @HEALTHCARE_HOL_DB.CLINICAL.SEMANTIC_MODELS_STAGE

Use COPY FILES INTO to transfer it.
```

### 2.2 Claims Model
```
Set up Cortex Analyst for insurance claims data using the pre-built YAML
model in our GitHub repository at:

@HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/healthcare/scripts/semantic_models/CLAIMS_ANALYTICS_MODEL.yaml

Note: the YAML file can't be read directly from the Git stage. Instead,
read the file contents from the stage and use
SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML to register it as a semantic view
in HEALTHCARE_HOL_DB.CLINICAL.
```

### 2.3 Inspect -- Snowsight UI
Guide attendees to AI & ML > Analyst to test the PATIENT_CARE semantic model.

---

## Step 3: Cortex Search

### 3.1 Bring PDF into Snowflake
```
Bring the following PDF from our GitHub repository into
HEALTHCARE_HOL_DB.CLINICAL so we can make it searchable:

@HOL_UTILS.PUBLIC.SNOWFLAKE_AI_HOL_REPO/branches/main/healthcare/pdfs/Clinical Operations Manual.pdf
```

### 3.2 Primary Prompt
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

### 3.3 Test Search -- Snowsight UI
Guide attendees to AI & ML > Search to test CLINICAL_DOCS_INFO.

---

## Step 4: Intelligence Agent

### 4.1 Primary Prompt
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

### 4.2/4.3 -- Snowsight UI
Test in AI & ML > Agents > HEALTHCARE_AGENT Playground.

---

## Step 5: Streamlit App

### 5.1 Chat Page
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

### 5.2 Dashboard Page
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

### 5.3 Optimization Page
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
