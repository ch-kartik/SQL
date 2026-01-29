-- Day 38 - Advanced Window Functions

-- 1. Month-over-month revenue change

WITH prev_revenue AS (
SELECT customer_id, month, revenue, 
	LAG(revenue) OVER(PARTITION BY customer_id ORDER BY month) AS prev_revenue
FROM monthly_revenue_d38
)
SELECT customer_id, month, revenue, prev_revenue, revenue - prev_revenue AS revenue_change 
FROM prev_revenue;

-- 2. Forward-looking revenue check (LEAD)

SELECT customer_id, month, revenue, 
	LEAD(revenue) OVER(PARTITION BY customer_id ORDER BY month) AS next_month_revenue
FROM monthly_revenue_d38;

-- 3. Cumulative (running) revenue per customer

SELECT customer_id, month, revenue, 
	SUM(revenue) OVER(PARTITION BY customer_id ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue
FROM monthly_revenue_d38;

-- 4. 2-month rolling average revenue

SELECT customer_id, month, revenue, AVG(revenue) OVER(PARTITION BY customer_id ORDER BY month ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS rolling_2_month_avg
FROM monthly_revenue_d38;

-- Business Questions

-- 1. Why might leadership prefer a rolling average instead of raw monthly revenue?
/* Leadership prefer a rolling average instead of raw monthly revenue because it removes short term noise and volatility providing clear and accurate details of 
business trends */

-- 2. How can LEAD() help detect churn before it happens?
/* LEAD() helps identify upcoming drops. It helps in predective analysis and helps detect churn risk by identifying and checking behaviour shift. */

-- 3. If a customer’s cumulative revenue is rising but MoM revenue is falling, what does that indicate?
/* This shows that customer is brining in revenue but th rate of growth is slowing down, stalling, or shrinking. */ 
