# Digital Media Planning and Budget Tracker

A centralized system to plan digital ad campaigns, manage a ₹10,00,000 marketing budget across 5 platforms, track vendors and invoices, monitor timelines and deliverables, and analyze spending against plan.

**Tools used:** Excel, Power Query, SQL, DAX / Power BI, HTML, CSS, JavaScript

## Quick start

| Want to… | Open |
|---|---|
| See the interactive dashboard | `Dashboard/index.html`. Double-click it; it works offline in any browser. |
| Use or edit the tracker | `Data/Digital_Media_Planning_Tracker.xlsx` (blue text = inputs) |
| Run the SQL | `SQL/database_queries.sql` in MySQL Workbench |
| Build the Power BI version | `PowerBI/PowerBI_Build_Guide.md` and `PowerBI/DAX_Measures.dax` |
| Read the write-up | `Documentation/Project_Documentation.pdf` |

## Folder structure

```
Digital_Media_Planning_Tracker/
├── Data/
│   ├── Digital_Media_Planning_Tracker.xlsx   all 7 modules + Spend_Log + Dashboard sheet
│   └── csv/                                  Campaigns, Vendors, Spend_Log, Invoices, Tasks
├── Dashboard/
│   └── index.html                            interactive web dashboard (self-contained)
├── SQL/
│   └── database_queries.sql                  schema + sample data + 10 analysis queries
├── PowerBI/
│   ├── DAX_Measures.dax                      date table, calculated columns, 19 measures
│   └── PowerBI_Build_Guide.md                step-by-step build of the .pbix
├── Reports/
│   └── Monthly_Campaign_Report.pdf           dashboard snapshot, 23 Nov 2026
└── Documentation/
    ├── Project_Documentation.pdf             problem, data model, formulas, insights, resume bullets
    └── Project_Documentation.md
```

## Headline findings (report date 23 Nov 2026)

- 77% of the budget is spent: ₹7.7L of ₹10L.
- At its current pace, Winter Sale (Google Ads) will spend about ₹4.79L against a ₹3L plan.
- ₹1.22L of invoices are overdue across 3 vendors.
- 2 deliverables are past deadline.

*The sample data is fictional.*
