# Cortex Code Hands-On Lab -- Multi-Industry Edition

## From Raw Data to a Conversational AI Agent with Snowflake -- in 90 Minutes

---

### Overview

This lab lets attendees build a fully functional AI-powered assistant using **only natural language prompts** in Snowflake's Cortex Code IDE. Three industry tracks are available -- each follows the same 6-step structure but with domain-specific data, models, and applications.

### Architecture

```
Step 0 (Shared)           Step 1-5 (Per Track)
┌─────────────────┐       ┌──────────────────────────────┐
│ Login            │       │ 1. Build Database            │
│ Open Cortex Code │──────>│ 2. Create Semantic Layer      │
│ Connect to GitHub│       │ 3. Set Up Document Search     │
│ Pick a Track     │       │ 4. Build Intelligence Agent   │
└─────────────────┘       │ 5. Build Streamlit App        │
                          └──────────────────────────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
              Healthcare      Financial Svcs      Industrial
              Providers       Portfolio/Risk    Equipment Maint
```

### Industry Tracks

| Track | Database | Agent | Optimizer | Tables |
|-------|----------|-------|-----------|--------|
| Healthcare (Providers) | HEALTHCARE_HOL_DB | HEALTHCARE_AGENT | Bed Allocation | 11 |
| Financial Services | FINSERV_HOL_DB | FINSERV_AGENT | Portfolio Rebalancing | 9 |
| Industrial / Manufacturing | INDUSTRIAL_HOL_DB | INDUSTRIAL_AGENT | Maintenance Scheduling | 10 |

### What Attendees Build (per track)

- A domain-specific database with realistic sample data
- Semantic models for text-to-SQL analytics
- A search engine over domain documentation (Cortex Search)
- A Snowflake Intelligence Agent with 3 tools
- A 3-page Streamlit app (Chat + Dashboard + Optimizer)

---

### Repository Structure

```
cortex-code-hol/
├── README.md                          (this file)
├── SE_FACILITATION_GUIDE.md           (internal SE guide, all tracks)
│
├── shared/
│   └── LAB_GUIDE.md                   (Step 0: login, Cortex Code, GitHub, track selection)
│
├── healthcare/
│   ├── LAB_GUIDE.md                   (Steps 1-5 for Healthcare)
│   ├── PROMPT_LIBRARY.md              (primary + fallback prompts)
│   ├── scripts/
│   │   ├── setup.sql                  (DB, 11 tables, sample data)
│   │   └── semantic_models/
│   │       └── CLAIMS_ANALYTICS_MODEL.yaml
│   └── pdfs/
│       └── Clinical Operations Manual.pdf
│
├── financial-services/
│   ├── LAB_GUIDE.md
│   ├── PROMPT_LIBRARY.md
│   ├── scripts/
│   │   ├── setup.sql                  (DB, 9 tables, sample data)
│   │   └── semantic_models/
│   │       └── MARKET_RISK_MODEL.yaml
│   └── pdfs/
│       └── Risk Management Framework.pdf
│
├── industrial/
│   ├── LAB_GUIDE.md
│   ├── PROMPT_LIBRARY.md
│   ├── scripts/
│   │   ├── setup.sql                  (DB, 10 tables, sample data)
│   │   └── semantic_models/
│   │       └── ENERGY_CONSUMPTION_MODEL.yaml
│   └── pdfs/
│       └── Maintenance Operations Guide.pdf
│
└── (legacy files from original single-track build)
    ├── LAB_GUIDE.md, PROMPT_LIBRARY.md
    ├── scripts/, pdfs/, streamlit_app/
    └── run_setup.py
```

---

### Event Schedule

| City | Date | Lead SE |
|------|------|---------|
| New York | May 14, 2025 | Johnny Kamel |
| King of Prussia | May 20, 2025 | Akshata |
| Boston | June 11, 2025 | Dalton |

### Time Allocation (90 minutes)

| Block | Duration | Content |
|-------|----------|---------|
| Intro + Step 0 | 15 min | Welcome, login, Cortex Code overview, GitHub setup, track selection |
| Step 1 | 10 min | Database creation |
| Step 2 | 12 min | Semantic model generation |
| Step 3 | 8 min | Document search setup |
| Step 4 | 10 min | Agent creation + testing |
| Step 5 | 25 min | Streamlit app (chat + dashboard + optimization) |
| Wrap-up | 5 min | Summary, resources, NPS |

---

### Key Technical Requirements

- **Accounts:** Snowflake trial accounts with ACCOUNTADMIN
- **Cross-region:** `ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION'`
- **GitHub repo:** Public, accessible from trial accounts
- **Trial limitations:** No EXTERNAL ACCESS INTEGRATION (WEB_SEARCH, WEB_SCRAPE, SEND_MAIL unavailable)

### Getting Started

1. Read `shared/LAB_GUIDE.md` for Step 0 (same for all tracks)
2. Pick a track and follow its `LAB_GUIDE.md` for Steps 1-5
3. SEs: read `SE_FACILITATION_GUIDE.md` for timing, troubleshooting, and talking points
