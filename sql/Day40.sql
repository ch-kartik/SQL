-- Day 40 - Window Functions Consolidation

-- Create one final result table.

/*
customer_id
month
revenue
prev_month_revenue
mom_growth_pct
rolling_3_month_avg
growth_trend
churn_risk_flag

*/

WITH month_rev AS (
SELECT cust_id, month, revenue, 
	 LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_month_revenue,
     LAG(revenue, 1) OVER(PARTITION BY cust_id ORDER BY month) AS prev_revenue,
     LAG(revenue, 2) OVER(PARTITION BY cust_id ORDER BY month) AS prev2_revenue
FROM customer_revenue_d40
)
SELECT cust_id, month, revenue, prev_month_revenue,
	CASE
    WHEN prev_month_revenue = 0 OR prev_month_revenue IS NULL THEN NULL
    ELSE (revenue - prev_month_revenue ) * 100.0 / prev_month_revenue
    END AS mom_growth_pct,
    AVG(revenue) OVER(PARTITION BY cust_id ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3_month_avg,
    CASE
    WHEN prev_month_revenue IS NULL THEN 'First Month'
    WHEN revenue = prev_month_revenue THEN 'Flat'
    WHEN revenue > prev_month_revenue THEN 'Growing'
    WHEN revenue < prev_month_revenue THEN 'Declining'
    END AS growth_trend,
    CASE
    WHEN revenue = 0 OR (prev2_revenue > prev_revenue AND prev_revenue > revenue) THEN 'Churn Risk'
    ELSE 'Stable'
    END AS churn_risk_flag
FROM month_rev;

-- Business Questions

-- 1. How would a retention team use this table?
-- Identify at-risk customers early, prioritize outreach, and trigger retention actions before revenue drops to zero

-- 2. Which column is most important for leadership and why?
-- churn_risk_flag is importantas it provides clear view of churn exposure which allows to track churn trend earlier.

-- 3. If you could add one more column, what would it be and why?
-- estimated_revenue_at_risk as it will help translate churn into how much revenue is at risk.