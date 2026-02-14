-- Day 43 - Executive-Level SQL Case — Churn Impact & Revenue Risk

/*
Business Context: 
You are the only analyst in a SaaS startup.

The CEO asks: “If customers churn next month, how much revenue are we at risk of losing — and who should we save first?”

You have only payment data.
*/

-- 1. Latest month per customer

WITH latest_month AS (
SELECT cust_id, MAX(DATE_FORMAT(payment_date, '%Y-%m-01')) AS latest_month
FROM payments_d43
GROUP BY cust_id
),
curr_month AS (
SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d43
GROUP BY cust_id, month
)
SELECT l.cust_id, l.latest_month, c.revenue
FROM latest_month l LEFT JOIN curr_month c
ON l.cust_id = c.cust_id
AND c.month = l.latest_month;

-- 2. Revenue trend classification

WITH monthly AS (
SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d43
GROUP BY cust_id, month
),
ranked AS (
SELECT cust_id, revenue,
	LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_revenue,
    ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY month DESC) AS rn
FROM monthly
)
SELECT cust_id,
	CASE 
    WHEN prev_revenue IS NULL THEN 'Single Month'
    WHEN revenue > prev_revenue THEN 'Growing'
    WHEN revenue < prev_revenue THEN 'Declining'
    ELSE 'Flat'
  END AS trend
FROM ranked
WHERE rn = 1;

-- 3. Churn risk flag

WITH monthly AS (
SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d43
GROUP BY cust_id, month
),
latest_month AS (
SELECT MAX(month) AS latest_month
FROM monthly
),
rev_with_lag AS (
SELECT cust_id, month, revenue, LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_revenue
FROM monthly
)
SELECT c.cust_id, 
	CASE 
    WHEN r.month IS NULL THEN 'High Churn Risk'
    WHEN r.revenue < r.prev_revenue THEN 'High Churn Risk'
    ELSE 'Low Risk'
	END AS churn_risk
FROM (SELECT DISTINCT cust_id FROM monthly) c
LEFT JOIN rev_with_lag r
ON c.cust_id = r.cust_id
AND r.month = (SELECT latest_month FROM latest_month);
 
-- 4. Revenue at risk

WITH monthly AS(
SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d43
GROUP BY cust_id, month
),
ranked AS (
SELECT cust_id, month, revenue, 
	LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_month_revenue,
	ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY month DESC) AS rn
FROM monthly
)
SELECT cust_id,
	CASE
    WHEN revenue = 0 THEN prev_month_revenue
    WHEN revenue < prev_month_revenue THEN prev_month_revenue
    END AS revenue_at_risk
FROM ranked
WHERE rn = 1
AND ( revenue = 0 OR revenue < prev_month_revenue);


-- Business Questions

-- 1. Which customers should the CEO prioritize immediately?
-- Customer 3 has already stopped paying, and Customer 1 is showing revenue contraction — both represent immediate revenue risk

-- 2. How would you reduce churn risk without discounts?
-- Proactive outreach, product education and fixing friction points before renewal.

-- 3. If this analysis is wrong, what assumption is most dangerous?
-- Assuming lack of payment always equals churn — delays, billing cycles, and annual plans can distort this.