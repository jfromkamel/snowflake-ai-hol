# SE Facilitation Guide -- Cortex Code HOL (Multi-Industry)

**Internal Use Only**

---

## Pre-Event Checklist

- [ ] Trial accounts provisioned (one per attendee + 5 spares)
- [ ] Each trial account has ACCOUNTADMIN access
- [ ] Verify GitHub integration works: run the Step 0.3 prompt on one trial account to confirm `HOL_GITHUB_API` and `CORTEX_CODE_HOL_REPO` can be created and files are accessible
- [ ] Cross-region Cortex enabled on trial org (`CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION'`)
- [ ] Test ALL THREE tracks end-to-end on separate trial accounts the day before
- [ ] Fallback SQL scripts saved and accessible (Step 0 fallback is in shared/LAB_GUIDE.md)
- [ ] Wi-Fi tested and stable
- [ ] Decide track assignment method (see below)
- [ ] Name badges and swag ready

---

## Track Assignment

Assign attendees to one of three industry tracks. Options:

1. **By table** -- each table gets one track (simplest for SEs to support)
2. **By preference** -- let attendees choose at Step 0.4 (more engagement)
3. **By audience** -- if the event targets a specific industry, default everyone to that track

### Quick Reference by Track

| | Healthcare | Financial Services | Industrial |
|---|---|---|---|
| **Database** | HEALTHCARE_HOL_DB | FINSERV_HOL_DB | INDUSTRIAL_HOL_DB |
| **Schemas** | CLINICAL, OPERATIONS | PORTFOLIO, RISK | OPERATIONS, ENERGY |
| **Warehouse** | HEALTHCARE_HOL_WH | FINSERV_HOL_WH | INDUSTRIAL_HOL_WH |
| **Agent** | HEALTHCARE_AGENT | FINSERV_AGENT | INDUSTRIAL_AGENT |
| **Streamlit App** | HEALTHCARE_ASSISTANT_APP | FINSERV_ASSISTANT_APP | INDUSTRIAL_ASSISTANT_APP |
| **Search Service** | CLINICAL_DOCS_INFO | RISK_DOCS_INFO | MAINTENANCE_DOCS_INFO |
| **Semantic Models** | PATIENT_CARE + CLAIMS_ANALYTICS | PORTFOLIO_ANALYTICS + MARKET_RISK | EQUIPMENT_ANALYTICS + ENERGY_CONSUMPTION |
| **Tables** | 11 | 9 | 10 |
| **Optimizer** | Bed allocation | Portfolio rebalancing | Maintenance scheduling |

---

## Timing Cues for Lead SE

| Time | Action | SE Cue |
|------|--------|--------|
| 2:30 | Start hands-on | "Open Cortex Code -- we'll connect to GitHub first" |
| 2:35 | Step 0 complete | "Everyone should see a folder listing. Now pick your industry track" |
| 2:38 | Step 1 begins | "Copy the setup prompt from your track's lab guide" |
| 2:43 | Step 1 check | Walk room -- everyone should see table counts |
| 2:48 | Step 2 begins | "This is the wow moment -- watch Cortex Code generate a semantic model" |
| 2:55 | Step 2 check | If stuck on model generation, switch to fallback (copy from GitHub) |
| 3:00 | Step 3 begins | "Now we're adding document search" |
| 3:08 | Step 4 begins | "Time to wire everything into an agent" |
| 3:13 | Step 4.2/4.3 UI | "Navigate to AI & ML > Agents. Try the test questions in Playground" |
| 3:20 | Step 5 begins | "The grand finale -- let's build the app" |
| 3:28 | Step 5 check | Everyone should have chat working; dashboard prompt can be sent |
| 3:38 | Step 5 wrap | Even if optimization isn't done, show the pre-built version |
| 3:40 | Wrap-up | Thank attendees, show NPS QR code |

---

## Common Issues and Fixes

### Step 0: GitHub Repository Setup

**Issue:** "Insufficient privileges to create API integration"
**Fix:** Cortex Code should switch to ACCOUNTADMIN automatically, but if not:
```sql
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE API INTEGRATION HOL_GITHUB_API
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/Snowflake-Labs/')
  ENABLED = TRUE;
```

**Issue:** "Repository already exists" error
**Fix:** This is fine -- the prompt uses CREATE OR REPLACE. If it persists, run:
```sql
ALTER GIT REPOSITORY HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO FETCH;
LS @HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/;
```

**Issue:** GitHub is blocked by corporate/venue Wi-Fi
**Fix:** Ask the attendee to use their phone's hotspot for the initial setup only.

**Issue:** `LS @HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO` returns empty
**Fix:** `ALTER GIT REPOSITORY HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO FETCH;`

### Step 1: Setup Script (all tracks)

**Issue:** "Script is too large for a single execution"
**Fix:** Use the fallback prompt which reads from the same Git stage path but breaks into sections.

**Issue:** "Role does not have privileges"
**Fix:** `USE ROLE ACCOUNTADMIN;`

**Issue:** "Warehouse already exists" or other object conflict
**Fix:** This is fine -- the script uses CREATE OR REPLACE.

### Step 2: Semantic Model (all tracks)

**Issue:** Cortex Code generates an incomplete or malformed model
**Fix:** Switch to fallback immediately -- copy the pre-built model from GitHub using the fallback prompt in the track's PROMPT_LIBRARY.md.

**Issue:** COPY FILES INTO fails from Git stage
**Fix:** Check `LS @HOL_UTILS.PUBLIC.CORTEX_CODE_HOL_REPO/branches/main/<track>/scripts/semantic_models/;`

### Step 3: Cortex Search (all tracks)

**Issue:** PDF isn't brought in / stage is empty
**Fix:** Re-run the 3.1 prompt or use `COPY FILES INTO` manually.

**Issue:** "PARSE_DOCUMENT is not available in this region"
**Fix:** `ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';`

**Issue:** Search service creation takes too long
**Fix:** Normal -- 2-5 minutes. Move on to explaining what's happening.

**Issue:** "Warehouse too small for PARSE_DOCUMENT"
**Fix:** Already in the prompt, but verify the warehouse scaled up.

### Step 4: Agent Creation (all tracks)

**Issue:** Agent creation fails -- tool can't find the semantic model
**Fix:** Check semantic views exist:
```
Show me all semantic views in <TRACK_DB>.<SCHEMA>
```

**Issue:** Agent doesn't return results when queried
**Fix:** Check that semantic models are in the stage and search service is active.

### Step 5: Streamlit App (all tracks)

**Issue:** App creation fails
**Fix:** Ensure Cortex Code creates the app in Snowflake (not local files).

**Issue:** "Module scipy not found"
**Fix:** Ensure environment.yml includes scipy.

**Issue:** Agent API returns 403 or auth error
**Fix:** Verify the app uses `get_active_session()` for auth.

---

## Pacing Tips

- **If group is ahead of schedule:** Let them explore agent questions or try another track
- **If group is behind:** Skip semantic model generation (use pre-built). Skip optimization page (show demo)
- **If one person is stuck:** Pair them with a neighbor. If widespread, switch to fallback for that step
- **The critical path is Steps 1-4.** Step 5 (Streamlit) is impressive but the core value is delivered by Step 4

---

## Talking Points by Step

### Step 0 -- GitHub Integration
"Notice we didn't ask anyone to download files or set up anything manually. One prompt connected Snowflake to GitHub and every file is now accessible."

### Step 1 -- Database Setup
"You didn't write any SQL. You told Cortex Code what you wanted, and it built an entire database with realistic sample data."

### Step 2 -- Semantic Models
"This is normally hours of data engineering work. You just generated a semantic model with business rules and verified queries in under 2 minutes."

### Step 3 -- Cortex Search
"You just built a RAG pipeline -- PDF parsing, chunking, embedding, and search indexing -- in 2 lines of conversation."

### Step 4 -- Agent
"This agent understands when to query structured data and when to search documents. It's reasoning about intent, not following hard-coded rules."

### Step 5 -- Streamlit
"You now have a production-quality application with chat, dashboards, and optimization. This could be deployed to your entire organization tomorrow."

---

## Post-Event Follow-Up

- Send attendees the resources packet:
  - Lab guide PDF (their track)
  - Trial account extension info (30 days)
  - Links to Snowflake documentation
  - Recording of the session (if applicable)
- Follow up within 48 hours for 1:1 meeting scheduling
- Log event notes in Salesforce
