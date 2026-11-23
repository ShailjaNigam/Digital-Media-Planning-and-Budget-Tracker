-- =====================================================================
-- Digital Media Planning & Budget Tracker - database and analysis queries
-- Dialect: MySQL 8 (notes for PostgreSQL at the bottom)
-- Sample data: fictional company, Oct-Dec 2026, total budget Rs 10,00,000
-- =====================================================================

DROP DATABASE IF EXISTS media_tracker;
CREATE DATABASE media_tracker;
USE media_tracker;

-- ---------- 1. Tables ----------
CREATE TABLE campaigns (
  campaign_id      VARCHAR(10) PRIMARY KEY,
  campaign_name    VARCHAR(100) NOT NULL,
  platform         VARCHAR(30)  NOT NULL,
  objective        VARCHAR(30),
  target_audience  VARCHAR(100),
  owner            VARCHAR(60),
  start_date       DATE NOT NULL,
  end_date         DATE NOT NULL,
  planned_budget   DECIMAL(12,2) NOT NULL,
  status           VARCHAR(20) NOT NULL   -- Planned / Active / Paused / Completed
);

CREATE TABLE vendors (
  vendor_id        VARCHAR(10) PRIMARY KEY,
  vendor_name      VARCHAR(100) NOT NULL,
  service          VARCHAR(60),
  campaign_id      VARCHAR(10),
  contract_amount  DECIMAL(12,2),
  status           VARCHAR(20),           -- Active / Pending / Inactive
  FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

CREATE TABLE spend_log (
  spend_id     VARCHAR(10) PRIMARY KEY,
  spend_date   DATE NOT NULL,
  campaign_id  VARCHAR(10) NOT NULL,
  vendor_id    VARCHAR(10) NOT NULL,
  amount       DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id),
  FOREIGN KEY (vendor_id)   REFERENCES vendors(vendor_id)
);

CREATE TABLE invoices (
  invoice_id      VARCHAR(10) PRIMARY KEY,
  vendor_id       VARCHAR(10) NOT NULL,
  campaign_id     VARCHAR(10) NOT NULL,
  invoice_amount  DECIMAL(12,2) NOT NULL,
  invoice_date    DATE NOT NULL,
  due_date        DATE NOT NULL,
  payment_date    DATE NULL,             -- NULL = not paid yet
  FOREIGN KEY (vendor_id)   REFERENCES vendors(vendor_id),
  FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

CREATE TABLE tasks (                      -- Timeline milestones + Deliverables
  task_id      VARCHAR(10) PRIMARY KEY,
  campaign_id  VARCHAR(10) NOT NULL,
  task_name    VARCHAR(100) NOT NULL,
  task_type    VARCHAR(20) NOT NULL,     -- Timeline / Deliverable
  assigned_to  VARCHAR(60),
  start_date   DATE,
  end_date     DATE,                     -- deadline for deliverables
  status       VARCHAR(20),              -- Pending / In Progress / Completed
  FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

-- ---------- 2. Sample data ----------
INSERT INTO campaigns (campaign_id, campaign_name, platform, objective, target_audience, owner, start_date, end_date, planned_budget, status) VALUES
  ('C101', 'Product Launch', 'Instagram', 'Awareness', '18-30, urban, lifestyle', 'Riya Sharma', '2026-10-01', '2026-11-15', 160000, 'Completed'),
  ('C102', 'Winter Sale', 'Google Ads', 'Conversions', 'In-market shoppers', 'Arjun Mehta', '2026-10-20', '2026-12-25', 300000, 'Active'),
  ('C103', 'Brand Awareness', 'YouTube', 'Reach', '18-45, all metros', 'Neha Verma', '2026-10-10', '2026-12-10', 200000, 'Active'),
  ('C104', 'Hiring Campaign', 'LinkedIn', 'Leads', 'Engineers & PMs, 2-8 yrs', 'Karan Gupta', '2026-10-15', '2026-12-20', 150000, 'Active'),
  ('C105', 'Festive Offers', 'Facebook', 'Engagement', '25-50, tier 1-2 cities', 'Pooja Iyer', '2026-10-05', '2026-11-30', 150000, 'Active'),
  ('C106', 'New Year Teaser', 'Instagram', 'Awareness', '18-30, urban', 'Riya Sharma', '2026-12-05', '2026-12-31', 40000, 'Planned');

INSERT INTO vendors (vendor_id, vendor_name, service, campaign_id, contract_amount, status) VALUES
  ('V101', 'ABC Media', 'Social Ads', 'C101', 160000, 'Active'),
  ('V102', 'XYZ Digital', 'Google Ads', 'C102', 300000, 'Active'),
  ('V103', 'Creative Studio', 'Video Ads', 'C103', 150000, 'Active'),
  ('V104', 'Media Solutions', 'Lead Generation', 'C104', 100000, 'Active'),
  ('V105', 'Social Spark', 'Facebook Ads', 'C105', 120000, 'Active'),
  ('V106', 'PixelCraft', 'Influencer Marketing', 'C106', 40000, 'Pending');

INSERT INTO spend_log (spend_id, spend_date, campaign_id, vendor_id, amount) VALUES
  ('S001', '2026-10-01', 'C101', 'V101', 18500),
  ('S002', '2026-10-05', 'C105', 'V105', 11000),
  ('S003', '2026-10-06', 'C101', 'V101', 12000),
  ('S004', '2026-10-10', 'C103', 'V103', 16000),
  ('S005', '2026-10-10', 'C105', 'V105', 12500),
  ('S006', '2026-10-11', 'C101', 'V101', 14500),
  ('S007', '2026-10-15', 'C103', 'V103', 18000),
  ('S008', '2026-10-15', 'C104', 'V104', 9000),
  ('S009', '2026-10-15', 'C105', 'V105', 14500),
  ('S010', '2026-10-16', 'C101', 'V101', 14000),
  ('S011', '2026-10-20', 'C102', 'V102', 33000),
  ('S012', '2026-10-20', 'C103', 'V103', 11000),
  ('S013', '2026-10-20', 'C104', 'V104', 9000),
  ('S014', '2026-10-20', 'C105', 'V105', 13000),
  ('S015', '2026-10-21', 'C101', 'V101', 19500),
  ('S016', '2026-10-25', 'C102', 'V102', 39500),
  ('S017', '2026-10-25', 'C103', 'V103', 18000),
  ('S018', '2026-10-25', 'C104', 'V104', 14500),
  ('S019', '2026-10-25', 'C105', 'V105', 14500),
  ('S020', '2026-10-26', 'C101', 'V101', 19000),
  ('S021', '2026-10-30', 'C102', 'V102', 28500),
  ('S022', '2026-10-30', 'C103', 'V103', 17000),
  ('S023', '2026-10-30', 'C104', 'V104', 12500),
  ('S024', '2026-10-30', 'C105', 'V105', 12500),
  ('S025', '2026-10-31', 'C101', 'V101', 21000),
  ('S026', '2026-11-04', 'C102', 'V102', 32500),
  ('S027', '2026-11-04', 'C103', 'V103', 14000),
  ('S028', '2026-11-04', 'C104', 'V104', 14000),
  ('S029', '2026-11-04', 'C105', 'V105', 13500),
  ('S030', '2026-11-05', 'C101', 'V101', 13000),
  ('S031', '2026-11-09', 'C102', 'V102', 43000),
  ('S032', '2026-11-09', 'C103', 'V103', 12000),
  ('S033', '2026-11-09', 'C104', 'V104', 13500),
  ('S034', '2026-11-09', 'C105', 'V105', 8500),
  ('S035', '2026-11-10', 'C101', 'V101', 16000),
  ('S036', '2026-11-14', 'C102', 'V102', 40500),
  ('S037', '2026-11-14', 'C103', 'V103', 19500),
  ('S038', '2026-11-14', 'C104', 'V104', 12000),
  ('S039', '2026-11-14', 'C105', 'V105', 10000),
  ('S040', '2026-11-15', 'C101', 'V101', 12500),
  ('S041', '2026-11-19', 'C102', 'V102', 33000),
  ('S042', '2026-11-19', 'C103', 'V103', 14500),
  ('S043', '2026-11-19', 'C104', 'V104', 15500),
  ('S044', '2026-11-19', 'C105', 'V105', 10000);

INSERT INTO invoices (invoice_id, vendor_id, campaign_id, invoice_amount, invoice_date, due_date, payment_date) VALUES
  ('INV101', 'V101', 'C101', 45000, '2026-10-17', '2026-11-01', '2026-10-31'),
  ('INV102', 'V103', 'C103', 34000, '2026-10-17', '2026-11-01', '2026-10-30'),
  ('INV103', 'V104', 'C104', 9000, '2026-10-17', '2026-11-01', '2026-10-31'),
  ('INV104', 'V105', 'C105', 38000, '2026-10-17', '2026-11-01', '2026-10-28'),
  ('INV105', 'V101', 'C101', 73500, '2026-11-02', '2026-11-17', '2026-11-15'),
  ('INV106', 'V102', 'C102', 101000, '2026-11-02', '2026-11-17', '2026-11-14'),
  ('INV107', 'V103', 'C103', 46000, '2026-11-02', '2026-11-17', NULL),
  ('INV108', 'V104', 'C104', 36000, '2026-11-02', '2026-11-17', NULL),
  ('INV109', 'V105', 'C105', 40000, '2026-11-02', '2026-11-17', NULL),
  ('INV110', 'V101', 'C101', 41500, '2026-11-17', '2026-12-02', NULL),
  ('INV111', 'V102', 'C102', 116000, '2026-11-17', '2026-12-02', NULL),
  ('INV112', 'V103', 'C103', 45500, '2026-11-17', '2026-12-02', NULL),
  ('INV113', 'V104', 'C104', 39500, '2026-11-17', '2026-12-02', NULL),
  ('INV114', 'V105', 'C105', 32000, '2026-11-17', '2026-12-02', NULL);

INSERT INTO tasks (task_id, campaign_id, task_name, task_type, assigned_to, start_date, end_date, status) VALUES
  ('T001', 'C101', 'Creative Design', 'Timeline', 'Design Team', '2026-09-24', '2026-09-28', 'Completed'),
  ('T002', 'C101', 'Ad Approval', 'Timeline', 'Riya Sharma', '2026-09-29', '2026-09-30', 'Completed'),
  ('T003', 'C101', 'Campaign Launch', 'Timeline', 'ABC Media', '2026-10-01', '2026-11-15', 'Completed'),
  ('T004', 'C101', 'Instagram Creatives', 'Deliverable', 'Design Team', '2026-09-24', '2026-09-28', 'Completed'),
  ('T005', 'C101', 'Reels Cut-downs', 'Deliverable', 'Video Team', '2026-10-10', '2026-10-18', 'Completed'),
  ('T006', 'C102', 'Landing Page', 'Timeline', 'Web Team', '2026-10-12', '2026-10-19', 'Completed'),
  ('T007', 'C102', 'Keyword Research', 'Timeline', 'XYZ Digital', '2026-10-14', '2026-10-19', 'Completed'),
  ('T008', 'C102', 'Campaign Live', 'Timeline', 'XYZ Digital', '2026-10-20', '2026-12-25', 'In Progress'),
  ('T009', 'C102', 'Search Ad Copy', 'Deliverable', 'Content Team', '2026-10-14', '2026-10-18', 'Completed'),
  ('T010', 'C102', 'Year-end Offer Banners', 'Deliverable', 'Design Team', '2026-11-15', '2026-11-28', 'In Progress'),
  ('T011', 'C103', 'Script & Storyboard', 'Timeline', 'Creative Studio', '2026-09-25', '2026-10-03', 'Completed'),
  ('T012', 'C103', 'Campaign Live', 'Timeline', 'Creative Studio', '2026-10-10', '2026-12-10', 'In Progress'),
  ('T013', 'C103', 'Promotional Video (30s)', 'Deliverable', 'Video Team', '2026-10-01', '2026-10-08', 'Completed'),
  ('T014', 'C103', 'Bumper Ads (6s)', 'Deliverable', 'Video Team', '2026-11-05', '2026-11-18', 'In Progress'),
  ('T015', 'C104', 'Job Post Copy', 'Deliverable', 'Content Team', '2026-10-08', '2026-10-12', 'Completed'),
  ('T016', 'C104', 'Lead Form Setup', 'Timeline', 'Media Solutions', '2026-10-10', '2026-10-14', 'Completed'),
  ('T017', 'C104', 'Campaign Live', 'Timeline', 'Media Solutions', '2026-10-15', '2026-12-20', 'In Progress'),
  ('T018', 'C104', 'Employer Brand Video', 'Deliverable', 'Video Team', '2026-11-10', '2026-11-20', 'Pending'),
  ('T019', 'C105', 'Festive Creatives', 'Deliverable', 'Design Team', '2026-09-28', '2026-10-03', 'Completed'),
  ('T020', 'C105', 'Campaign Live', 'Timeline', 'Social Spark', '2026-10-05', '2026-11-30', 'In Progress'),
  ('T021', 'C105', 'Retargeting Audience', 'Timeline', 'Social Spark', '2026-11-01', '2026-11-06', 'Completed'),
  ('T022', 'C106', 'Influencer Shortlist', 'Timeline', 'PixelCraft', '2026-11-20', '2026-11-30', 'In Progress'),
  ('T023', 'C106', 'Teaser Creatives', 'Deliverable', 'Design Team', '2026-11-25', '2026-12-03', 'Pending'),
  ('T024', 'C106', 'Campaign Launch', 'Timeline', 'PixelCraft', '2026-12-05', '2026-12-31', 'Pending');

-- ---------- 3. Analysis queries ----------
-- Report date drives overdue / delayed logic. Use CURDATE() for live tracking.
SET @report_date = '2026-11-23';

-- Q1. Planned vs actual budget by platform, with remaining and utilization
SELECT c.platform,
       SUM(c.planned_budget)                                   AS planned_budget,
       COALESCE(SUM(s.actual), 0)                              AS actual_spend,
       SUM(c.planned_budget) - COALESCE(SUM(s.actual), 0)      AS remaining_budget,
       ROUND(COALESCE(SUM(s.actual), 0) / SUM(c.planned_budget) * 100, 1) AS utilization_pct
FROM campaigns c
LEFT JOIN (SELECT campaign_id, SUM(amount) AS actual FROM spend_log GROUP BY campaign_id) s
       ON s.campaign_id = c.campaign_id
GROUP BY c.platform
ORDER BY utilization_pct DESC;

-- Q2. Campaign-wise expenditure and forecast spend at the current daily pace
SELECT c.campaign_id, c.campaign_name, c.platform, c.status, c.planned_budget,
       COALESCE(s.actual, 0) AS actual_spend,
       CASE WHEN c.status = 'Active' AND @report_date > c.start_date
            THEN ROUND(COALESCE(s.actual, 0)
                       / (DATEDIFF(LEAST(@report_date, c.end_date), c.start_date) + 1)
                       * (DATEDIFF(c.end_date, c.start_date) + 1), 0)
            ELSE COALESCE(s.actual, 0) END AS forecast_spend
FROM campaigns c
LEFT JOIN (SELECT campaign_id, SUM(amount) AS actual FROM spend_log GROUP BY campaign_id) s
       ON s.campaign_id = c.campaign_id
ORDER BY actual_spend DESC;

-- Q3. Campaigns likely to overspend (forecast more than 5% above plan)
SELECT * FROM (
  SELECT c.campaign_name, c.platform, c.planned_budget,
         ROUND(SUM(s.amount) / (DATEDIFF(LEAST(@report_date, c.end_date), c.start_date) + 1)
               * (DATEDIFF(c.end_date, c.start_date) + 1), 0) AS forecast_spend
  FROM campaigns c JOIN spend_log s ON s.campaign_id = c.campaign_id
  WHERE c.status = 'Active'
  GROUP BY c.campaign_id, c.campaign_name, c.platform, c.planned_budget, c.start_date, c.end_date
) f
WHERE forecast_spend > planned_budget * 1.05
ORDER BY forecast_spend - planned_budget DESC;

-- Q4. Invoice status (Paid / Pending / Overdue) with days overdue
SELECT i.invoice_id, v.vendor_name, i.campaign_id, i.invoice_amount, i.due_date, i.payment_date,
       CASE WHEN i.payment_date IS NOT NULL THEN 'Paid'
            WHEN i.due_date < @report_date  THEN 'Overdue'
            ELSE 'Pending' END AS payment_status,
       CASE WHEN i.payment_date IS NULL AND i.due_date < @report_date
            THEN DATEDIFF(@report_date, i.due_date) ELSE 0 END AS days_overdue
FROM invoices i JOIN vendors v ON v.vendor_id = i.vendor_id
ORDER BY days_overdue DESC, i.due_date;

-- Q5. Invoice KPIs: total, paid, pending, overdue
SELECT SUM(invoice_amount)                                                        AS total_invoiced,
       SUM(CASE WHEN payment_date IS NOT NULL THEN invoice_amount ELSE 0 END)    AS total_paid,
       SUM(CASE WHEN payment_date IS NULL AND due_date >= @report_date THEN invoice_amount ELSE 0 END) AS pending_amount,
       SUM(CASE WHEN payment_date IS NULL AND due_date <  @report_date THEN invoice_amount ELSE 0 END) AS overdue_amount,
       SUM(CASE WHEN payment_date IS NULL AND due_date <  @report_date THEN 1 ELSE 0 END)              AS overdue_count
FROM invoices;

-- Q6. Vendor-wise spend, invoiced, paid and outstanding
SELECT v.vendor_id, v.vendor_name, v.status, v.contract_amount,
       COALESCE(s.spend, 0)                        AS spend_to_date,
       COALESCE(i.invoiced, 0)                     AS invoiced,
       COALESCE(i.paid, 0)                         AS paid,
       COALESCE(i.invoiced, 0) - COALESCE(i.paid, 0) AS outstanding,
       COALESCE(s.spend, 0) - COALESCE(i.invoiced, 0) AS not_yet_invoiced
FROM vendors v
LEFT JOIN (SELECT vendor_id, SUM(amount) AS spend FROM spend_log GROUP BY vendor_id) s ON s.vendor_id = v.vendor_id
LEFT JOIN (SELECT vendor_id, SUM(invoice_amount) AS invoiced,
                  SUM(CASE WHEN payment_date IS NOT NULL THEN invoice_amount ELSE 0 END) AS paid
           FROM invoices GROUP BY vendor_id) i ON i.vendor_id = v.vendor_id
ORDER BY outstanding DESC;

-- Q7. Monthly marketing expenditure
SELECT DATE_FORMAT(spend_date, '%Y-%m') AS spend_month, SUM(amount) AS actual_spend
FROM spend_log
GROUP BY DATE_FORMAT(spend_date, '%Y-%m')
ORDER BY spend_month;

-- Q8. Delayed deliverables and milestones
SELECT t.task_id, c.campaign_name, t.task_name, t.task_type, t.assigned_to, t.end_date, t.status,
       DATEDIFF(@report_date, t.end_date) AS days_late
FROM tasks t JOIN campaigns c ON c.campaign_id = t.campaign_id
WHERE t.status <> 'Completed' AND t.end_date < @report_date
ORDER BY days_late DESC;

-- Q9. Campaign status distribution
SELECT status, COUNT(*) AS campaigns FROM campaigns GROUP BY status ORDER BY campaigns DESC;

-- Q10. Dashboard KPI row in one query
SELECT (SELECT SUM(planned_budget) FROM campaigns)                          AS total_budget,
       (SELECT SUM(amount) FROM spend_log)                                  AS actual_spend,
       (SELECT SUM(planned_budget) FROM campaigns) - (SELECT SUM(amount) FROM spend_log) AS remaining_budget,
       ROUND((SELECT SUM(amount) FROM spend_log) / (SELECT SUM(planned_budget) FROM campaigns) * 100, 1) AS utilization_pct,
       (SELECT COUNT(*) FROM campaigns)                                     AS total_campaigns,
       (SELECT COUNT(*) FROM vendors WHERE status = 'Active')               AS active_vendors,
       (SELECT COUNT(*) FROM invoices WHERE payment_date IS NULL)           AS pending_invoices;

-- PostgreSQL notes: replace SET @report_date with a CTE  (WITH p AS (SELECT DATE '2026-11-23' AS report_date)),
-- DATEDIFF(a, b) with (a - b), LEAST works as-is, DATE_FORMAT(d,'%Y-%m') with TO_CHAR(d,'YYYY-MM').
