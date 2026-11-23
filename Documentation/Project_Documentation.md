---
title: "Digital Media Planning and Budget Tracker"
subtitle: "Project documentation"
---

# 1. Problem and objective

A company is launching a product and has a **₹10,00,000** digital marketing budget. It will advertise on Google Ads, Instagram, Facebook, YouTube and LinkedIn.

The marketing team needs one place to:

- plan campaigns
- allocate budget across platforms
- track vendors and invoices
- follow campaign timelines and deliverables
- see whether actual spend is on track against plan

**Objective:** build a centralized tracker and an interactive dashboard that answers four questions:

1. Where is the money going?
2. Which campaigns will overspend?
3. Which invoices or deliverables need action today?

# 2. What was built

| Layer | Output | Tool |
|---|---|---|
| Data entry and calculations | 9-sheet workbook with 357 live formulas, data validation, conditional formatting and 13 charts (including a Gantt chart) | Microsoft Excel |
| Data cleaning | Type setting, trimming, de-duplication, null handling | Power Query |
| Database | 5 normalized tables with keys, plus 10 analysis queries | SQL (MySQL 8) |
| KPIs | 19 measures, 4 calculated columns, a date table and a report-date parameter | DAX |
| Dashboard | Interactive web dashboard: 9 KPIs, 7 charts, 6 filters, 6 module views, auto-generated insights | HTML, CSS, JavaScript |
| BI dashboard | Step-by-step build guide | Power BI |

# 3. Data model

The brief's original tables were not linked well enough to build every chart, so the data model was redesigned before any data was entered:

| Problem in the original layout | Fix |
|---|---|
| Budget was tracked per platform, so campaign-wise spend was impossible | Planned budget is stored per campaign and rolled up to platform |
| No dated spend data, so no monthly trend or date filter | Added a **Spend_Log** table: one row per spend entry |
| Tables joined on names (typo-prone) | Every table joins on IDs (C101, V101) |
| No campaign status or owner column | Added Owner and Status columns |
| The invoice formula referred to its own cell (circular reference) | Added a Payment Date column; Status is calculated from it |
| Facebook had a budget but no campaign | Added C105 Festive Offers |

**Star schema**

- **Dimension tables:** Campaigns, Vendors, Date
- **Fact tables:** Spend_Log, Invoices, Tasks

Tasks combines timeline milestones and deliverables, with a Type column to tell them apart.

| Table | Rows | Key columns |
|---|---|---|
| Campaigns | 6 | Campaign ID, Platform, Owner, Start/End Date, Planned Budget, Status |
| Vendors | 6 | Vendor ID, Service, Campaign ID, Contract Amount, Status |
| Spend_Log | 44 | Date, Campaign ID, Vendor ID, Amount |
| Invoices | 14 | Invoice ID, Vendor ID, Amount, Invoice/Due/Payment Date |
| Tasks | 24 | Campaign ID, Task, Type, Assigned To, Start/End Date, Status |

# 4. Modules

1. **Campaign Planning:** objectives, platforms, audiences, owners, dates, planned budget. Also shows actual spend, remaining budget, utilization, days left and **forecast spend at the current pace**.
2. **Budget Tracker:** planned, actual and remaining budget plus utilization by platform, using `SUMIFS` from the source tables. Has 4 charts.
3. **Vendor Tracker:** contracts, spend to date, invoiced, paid, outstanding and not-yet-invoiced amounts, and the share of each contract used.
4. **Invoice Tracker:** status is calculated automatically.
5. **Timeline:** milestones per campaign, with a Gantt chart (a stacked bar chart with an invisible start series).
6. **Deliverables:** assets per campaign, with a delay flag and days late.
7. **Dashboard:** KPI cards and the 7 required charts.

**Key formulas (Excel)**

```
Remaining Budget    =B5-C5
Utilization         =IFERROR(C5/B5,0)
Actual by platform  =SUMIFS(Spend_Log!$E:$E,Spend_Log!$F:$F,A5)
Invoice status      =IF(H5<>"","Paid",IF(G5<Dashboard!$C$3,"Overdue","Pending"))
Delay flag          =IF(AND(G5<>"Completed",F5<Dashboard!$C$3),"Delayed","On Track")
Forecast spend      =IF(AND(J5="Active",RD>G5),K5/(MIN(RD,H5)-G5+1)*(H5-G5+1),K5)
```

`Dashboard!C3` is the **report date**. It is fixed to the data snapshot (23 Nov 2026) so the results can be reproduced. Change it to `=TODAY()` for live tracking.

# 5. Results (report date 23 Nov 2026)

| KPI | Value |
|---|---|
| Total marketing budget | ₹10,00,000 |
| Actual spend | ₹7,70,000 |
| Remaining budget | ₹2,30,000 |
| Budget utilization | 77% |
| Campaigns | 6 (4 active) |
| Active vendors | 5 |
| Pending invoices | 8, of which 3 are overdue (₹1,22,000) |
| Delayed deliverables | 2 |

**Planned vs actual by platform**

| Platform | Planned | Actual | Utilization |
|---|---|---|---|
| Google Ads | ₹3,00,000 | ₹2,50,000 | 83.3% |
| Instagram | ₹2,00,000 | ₹1,60,000 | 80.0% |
| Facebook | ₹1,50,000 | ₹1,20,000 | 80.0% |
| YouTube | ₹2,00,000 | ₹1,40,000 | 70.0% |
| LinkedIn | ₹1,50,000 | ₹1,00,000 | 66.7% |

# 6. Insights and recommendations

1. **Winter Sale (Google Ads) is on pace to spend about ₹4.79L against a ₹3L plan**, an overshoot of ₹1.79L. It has used 83% of its budget with 32 days left. *Recommendation:* cap daily spend at about ₹1,560 (₹50,000 remaining ÷ 32 days), or approve extra budget.
2. **Hiring Campaign (LinkedIn)** is pacing about ₹17.5k over plan. *Recommendation:* lower bids, or end the campaign a few days early.
3. **₹1.22L of invoices are overdue** (Creative Studio, Media Solutions and Social Spark), each 6 days past due. *Recommendation:* clear these before the next billing cycle to protect vendor relationships.
4. **2 deliverables are past deadline:** Bumper Ads (5 days late) and Employer Brand Video (3 days late). Both sit with the Video Team. *Recommendation:* the Video Team may be over capacity.
5. **₹73k of spend has not been invoiced yet.** *Recommendation:* include it in cash-flow planning for December.
6. **Festive Offers (Facebook)** is pacing ₹13k under plan. *Recommendation:* that money can partly offset the overspend in item 1.

# 7. How to run it

- **Web dashboard:** open `Dashboard/index.html` in any browser (no install needed), or use the published link. Filter by campaign, platform, vendor, status and date range, and change the report date to re-evaluate overdue and delayed items. The "Use your own data" panel accepts a JSON version of the tables.
- **Excel:** open `Data/Digital_Media_Planning_Tracker.xlsx`. Blue cells are inputs; every other number is a formula.
- **SQL:** run `SQL/database_queries.sql` in MySQL Workbench. It creates the database, loads the data and contains 10 queries.
- **Power BI:** follow `PowerBI/PowerBI_Build_Guide.md` using `PowerBI/DAX_Measures.dax`.

# 8. Resume description

**Digital Media Planning and Budget Tracker** | Excel, Power Query, SQL, DAX, Power BI, HTML/JS

- Designed a star-schema data model (5 tables, 44 spend records, 14 invoices) to track ₹10L of digital ad spend across 5 platforms, 6 campaigns and 6 vendors.
- Built an Excel tracker with 350+ formulas (SUMIFS, INDEX-MATCH, date logic) that automates budget utilization, invoice status (Paid / Pending / Overdue) and deliverable delay flags.
- Wrote 10 SQL queries and 19 DAX measures for KPIs, including a run-rate forecast that flagged a ₹1.79L projected overspend on the Google Ads campaign.
- Built an interactive dashboard with 9 KPIs, 7 charts and 6 filters, highlighting ₹1.22L in overdue invoices and 2 delayed deliverables.

# 9. Interview questions to prepare

- **Why a separate Spend_Log table?** Budget is planned once, but spend happens over time. A dated log lets you build the monthly trend, filter by date range, and calculate actual spend at any level (campaign, platform or vendor) from a single source.
- **Why join on IDs instead of names?** Names get typed differently in different places ("XYZ Digital" vs "XYZ digital"), and a mismatched name silently breaks the link. IDs are stable keys.
- **How does the forecast work?** Spend so far ÷ days elapsed = average daily spend. Multiply that by the total number of campaign days. It assumes spend continues at the same daily rate. Pacing or seasonality models could replace it.
- **Why is there a report date instead of TODAY()?** It makes the results reproducible: anyone opening the file sees the same numbers. Switching to `=TODAY()` turns on live tracking.
- **What would you add next?** Performance data (impressions, clicks, conversions) to calculate cost per click (CPC), cost per lead (CPL) and return on ad spend (ROAS), and alerts when utilization passes 90%.

*All company, vendor and person names in the sample data are fictional.*
