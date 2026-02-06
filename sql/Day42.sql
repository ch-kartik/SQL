-- Day 42 - Case-Based SQL — Subscription Churn & Revenue Health
/*
You work at a B2B SaaS company. Customers pay monthly and Revenue fluctuates

Leadership wants to understand:

a) Who is at risk of churn

b) Who is expanding

c) Who needs retention attention
*/

-- 1. Monthly revenue table

SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d42
GROUP BY cust_id, month;

-- 2. Revenue trend per customer-month

WITH current_rev AS (
SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d42
GROUP BY cust_id, month
),
prev_rev AS (
SELECT cust_id, month, revenue, LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_month_revenue
FROM current_rev
)
SELECT cust_id, month, revenue, prev_month_revenue,
	CASE
    WHEN prev_month_revenue IS NULL THEN 'First Month'
    WHEN revenue = prev_month_revenue THEN 'Flat'
    WHEN revenue > prev_month_revenue THEN 'Growing'
    WHEN revenue < prev_month_revenue THEN 'Declining'
    END AS growth_trend
FROM prev_rev;

-- 3. Identify churned customers

WITH cust_last_month AS (
SELECT cust_id, DATE_FORMAT(MAX(payment_date), '%Y-%m-01') AS last_month
FROM payments_d42
GROUP BY cust_id
),
latest_month AS (
SELECT DATE_FORMAT(MAX(payment_date), '%Y-%m-01') AS latest_month
FROM payments_d42
)
SELECT c.cust_id,
	CASE 
    WHEN c.last_month < l.latest_month THEN 'Churned'
    ELSE 'Active'
    END AS churn_status
FROM cust_last_month c CROSS JOIN latest_month l; 

-- 4. Revenue health classification

WITH monthly_rev AS (
SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d42
GROUP BY cust_id, month
),
latest_month AS (
SELECT MAX(month) AS latest_month
FROM monthly_rev
),
rev_with_lag AS (
SELECT cust_id, month, revenue, LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_revenue
FROM monthly_rev 
)
SELECT c.cust_id,
	CASE
    WHEN r.month IS NULL THEN 'Churned'
    WHEN r.revenue < r.prev_revenue THEN 'At Risk'
    ELSE 'Healthy'
    END AS revenue_health
FROM (SELECT DISTINCT cust_id FROM monthly_rev) c 
LEFT JOIN rev_with_lag r
    ON c.cust_id = r.cust_id
   AND r.month = (SELECT latest_month FROM latest_month);


-- Business Questions

-- 1. Why is “no payment in latest month” a stronger churn signal than revenue decline?
/* No payment indicates a break in the commercial relationship, whereas decline still indicates engagement. */

-- 2. Which customers should retention prioritize first and why?
/* Retention should prioritize high-ARPU customers who are missing in the latest month, followed by customers showing consistent decline. */

-- 3. If leadership could see only one metric from this analysis, what should it be?
-- Number and percentage of churned customers in the latest month, paired with revenue at risk.