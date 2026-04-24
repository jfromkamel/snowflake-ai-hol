# From Raw Data to a Conversational AI Agent with Snowflake -- in 90 Minutes

## Powered by Cortex Code

---

### About This Lab

In this hands-on lab, you will build a fully functional AI-powered assistant using **only natural language prompts** in Snowflake's Cortex Code IDE. No SQL writing, no YAML editing, no manual UI configuration -- you'll talk to Cortex Code and it will build everything for you.

**What you'll build:**
- A domain-specific database with realistic sample data
- Semantic models that let anyone query business metrics in plain English
- A search engine over unstructured documentation
- A Snowflake Intelligence Agent that routes questions to the right data source
- A multi-page Streamlit app with chat, dashboards, and optimization

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
   allowing the prefix https://github.com/Snowflake-Labs/
3. Create a Git repository object called CORTEX_CODE_HOL_REPO in the
   HOL_UTILS.PUBLIC schema pointing to:
   https://github.com/Snowflake-Labs/cortex-code-hol
4. Fetch the latest contents from the repository
5. Confirm everything worked by listing the top-level files and folders
   available in the main branch
```

> **What's happening:** Cortex Code is creating a live connection between your Snowflake account and the lab's GitHub repository. All scripts, models, and documents will be accessible directly from GitHub -- no manual file handling needed.

**Expected output:** You should see a folder listing including `shared/`, `healthcare/`, `financial-services/`, `industrial/`, and `README.md`.

> **Note:** This is the only prompt in the lab that requires ACCOUNTADMIN. Cortex Code will handle the role switching automatically.

### 0.4 Choose Your Industry Track

This lab offers three industry scenarios. Each one follows the same steps and delivers the same outcome -- an AI-powered agent and app -- but with data and questions tailored to a specific domain.

**Pick one and continue with that track's lab guide:**

| Track | Description | Continue with |
|-------|-------------|---------------|
| **Healthcare (Providers)** | Patient care analytics, readmission risk, bed management | [healthcare/LAB_GUIDE.md](../healthcare/LAB_GUIDE.md) |
| **Financial Services** | Portfolio analytics, market risk, compliance monitoring | [financial-services/LAB_GUIDE.md](../financial-services/LAB_GUIDE.md) |
| **Industrial / Manufacturing** | Equipment maintenance, production analytics, energy management | [industrial/LAB_GUIDE.md](../industrial/LAB_GUIDE.md) |

> **Tip:** If you're not sure which to pick, go with the one closest to your own industry. All three deliver the same "wow" moments.

---

## Appendix: Fallback SQL for Step 0.3

If Cortex Code can't handle the Git setup, run this SQL directly in a worksheet:

```sql
USE ROLE ACCOUNTADMIN;

CREATE DATABASE IF NOT EXISTS HOL_UTILS;
CREATE SCHEMA IF NOT EXISTS HOL_UTILS.PUBLIC;

CREATE OR REPLACE API INTEGRATION HOL_GITHUB_API
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/Snowflake-Labs/')
  ENABLED = TRUE;

CREATE OR REPLACE GIT REPOSITORY HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO
  API_INTEGRATION = HOL_GITHUB_API
  ORIGIN = 'https://github.com/Snowflake-Labs/cortex-code-hol';

ALTER GIT REPOSITORY HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO FETCH;

LS @HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/;
```
