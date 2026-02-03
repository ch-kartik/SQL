-- Day 41 - Case-Based SQL (Interview-Style Business Problem)
/* 
Business Case:

You work as a Data Analyst for a B2C subscription company.

Leadership asks:

“Which customers are becoming less valuable, and should be prioritized for retention?”

You’re given raw transactional data — not pre-cleaned metrics.

Your task is to turn raw data into actionable insights.
*/

-- 1. Monthly revenue per customer

SELECT p.cust_id, DATE_FORMAT(p.payment_date, '%Y-%m') AS month, SUM(p.amount) AS total_revenue
FROM payments_d41 p
GROUP BY p.cust_id, month;

-- 2. Revenue trend per customer - For each customer-month: current revenue, previous month revenue, growth trend (Growing / Declining / Flat / First Month)

WITH cur_rev AS (
SELECT p.cust_id, DATE_FORMAT(p.payment_date, '%Y-%m') AS month, SUM(p.amount) AS current_revenue
FROM payments_d41 p
GROUP BY p.cust_id, month
),
prev_month AS (
SELECT cust_id, month, current_revenue, LAG(current_revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_month_revenue
FROM cur_rev
)
SELECT cust_id, month, current_revenue, prev_month_revenue,
	CASE
    WHEN prev_month_revenue IS NULL THEN 'First Month'
    WHEN current_revenue = prev_month_revenue THEN 'Flat'
    WHEN current_revenue > prev_month_revenue THEN 'Growing'
    WHEN current_revenue < prev_month_revenue THEN 'Declining'
    END AS growth_trend
FROM prev_month;

-- 3. Identify at-risk customers

WITH monthly_rev AS (
SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d41
GROUP BY cust_id, month
),
rev_with_lag AS(
SELECT cust_id, month, revenue,
	LAG(revenue, 1) OVER(PARTITION BY cust_id ORDER BY month) AS prev_revenue, 	
	LAG(revenue, 2) OVER(PARTITION BY cust_id ORDER BY month) AS prev2_revenue
    FROM monthly_rev
),
latest_month AS (
SELECT MAX(month) AS max_month FROM monthly_rev
)
SELECT r.cust_id, 	
	CASE
    WHEN (r.prev2_revenue > r.prev_revenue AND r.prev_revenue > r.revenue) THEN 'At Risk'
    ELSE 'Stable'
    END AS risk_status
FROM rev_with_lag r CROSS JOIN latest_month l
WHERE r.month = l.max_month;

-- Business Questions

-- 1. Which customers should retention focus on first?
-- Customers showing consecutive revenue decline in the latest month should be prioritized, especially high-value customers with historical revenue.

-- 2. Which country shows higher churn risk?
-- Based on recent declining revenue trends, India currently shows higher churn risk