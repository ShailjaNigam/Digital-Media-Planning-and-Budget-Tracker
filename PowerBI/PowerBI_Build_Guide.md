# Power BI build guide

Follow these steps to build `Media_Planning_Dashboard.pbix` from the data in this project. Allow 1–2 days. Power BI Desktop is free and runs on Windows only. On a Mac, use a Windows VM, or use the Excel Dashboard sheet and the HTML dashboard instead.

## 1. Load the data (Power Query)

1. Open Power BI Desktop and go to **Home → Get Data → Text/CSV**. Load these files from `Data/csv/`, one at a time: `Campaigns.csv`, `Vendors.csv`, `Spend_Log.csv`, `Invoices.csv`, `Tasks.csv`.
   - The data is also in the Excel workbook, but that workbook contains formula columns. The CSVs hold the raw data only, which is the cleaner source.
2. Click **Transform Data** to open Power Query, then make these changes in each table:
   - Set the date columns to type **Date**, and the amount columns to **Fixed decimal number**.
   - Text columns: **Transform → Format → Trim**.
   - On the ID column: **Home → Remove Rows → Remove Duplicates**, then **Remove Blank Rows**.
   - In Invoices, keep blank `Payment Date` values as null. A null means the invoice is unpaid.
3. Click **Close & Apply**.

## 2. Model the relationships (Model view)

The model is a star schema, with Campaigns and Vendors as the main dimension tables.

| From (one side) | To (many side) |
|---|---|
| Campaigns[Campaign ID] | Spend_Log[Campaign ID] |
| Campaigns[Campaign ID] | Invoices[Campaign ID] |
| Campaigns[Campaign ID] | Tasks[Campaign ID] |
| Vendors[Vendor ID] | Spend_Log[Vendor ID] |
| Vendors[Vendor ID] | Invoices[Vendor ID] |
| Date[Date] | Spend_Log[Date] |
| Date[Date] | Invoices[Invoice Date] |

Do **not** create a relationship between Vendors[Campaign ID] and Campaigns. It would give Power BI two filter paths between the same tables, and Power BI will report the relationship as ambiguous.

## 3. Add the DAX

Copy everything from `DAX_Measures.dax`: the Date table, the Report Date table, the calculated columns and the measures.

- Select the Date table, then **Table tools → Mark as date table**.
- Set formats on the measures: currency for amounts, percentage for Budget Utilization %.

## 4. Build the report page

Canvas size: 16:9. Arrange it like this:

- **Top row:** 7 KPI cards (Card visual)
  - Total Budget
  - Actual Spend
  - Remaining Budget
  - Budget Utilization %
  - Total Campaigns
  - Active Vendors
  - Pending Invoices
- **Left panel:** slicers
  - Campaigns[Campaign Name]
  - Campaigns[Platform]
  - Vendors[Vendor Name]
  - Campaigns[Status]
  - Date[Date] (set to the *Between* style for a date range)
- **Charts:**

| # | Visual | Fields |
|---|---|---|
| 1 | Clustered column | X: Campaigns[Platform] · Y: Total Budget, Actual Spend |
| 2 | Donut | Legend: Campaigns[Platform] · Values: Total Budget |
| 3 | Clustered bar | Y: Campaigns[Campaign Name] · X: Actual Spend |
| 4 | Clustered bar | Y: Vendors[Vendor Name] · X: Actual Spend |
| 5 | Donut | Legend: Invoices[Payment Status] · Values: Total Invoiced |
| 6 | Column | X: Campaigns[Status] · Y: Total Campaigns |
| 7 | Line or column | X: Date[Month] · Y: Actual Spend |

Optional extra pages:

- **Invoices:** a table visual sorted by Days Overdue, with conditional formatting on Payment Status.
- **Timeline:** a Gantt custom visual (from AppSource, under *Get more visuals*) using the Tasks table.
- **Insights:** 3–4 text boxes with the findings listed in the documentation.

## 5. Test

Click every slicer value. The KPI cards should match the Excel Dashboard sheet:

| KPI | Expected value |
|---|---|
| Total Budget | ₹10,00,000 |
| Actual Spend | ₹7,70,000 |
| Utilization | 77% |
| Pending invoices | 8 |
| Overdue amount | ₹1,22,000 |

If a visual doesn't change when you use a slicer, a relationship is missing.

Save the file as `PowerBI/Media_Planning_Dashboard.pbix`.
