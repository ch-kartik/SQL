-- Day - 8 

-- 1. Customer revenue summary

WITH rev_month AS (
SELECT cust_id, SUM(revenue) AS total_revenue, COUNT(rev_month) AS active_months
FROM revenue_d8
GROUP BY cust_id
),
avg_month_rev AS (
SELECT cust_id, ROUND(AVG(revenue), 2) AS avg_monthly_revenue
FROM revenue_d8
GROUP BY cust_id
)
SELECT r.cust_id, r.total_revenue, r.active_months, a.avg_monthly_revenue
FROM rev_month r JOIN avg_month_rev a
ON r.cust_id = a.cust_id;

-- 2. Revenue tier segmentation

SELECT cust_id, 
	CASE 
    WHEN AVG(revenue) >=2500 THEN 'High'
    WHEN AVG(revenue) BETWEEN 1500 AND 2499 THEN 'Medium'
    WHEN AVG(revenue) < 1500 THEN 'Low'
    END AS revenue_tier
FROM revenue_d8
GROUP BY cust_id;

-- 3. Segment size & contribution

WITH avg_rev_per_cust AS (
SELECT cust_id, AVG(revenue) AS avg_revenue, SUM(revenue) AS total_revenue
FROM revenue_d8
GROUP BY cust_id
),
rev_tier AS (
SELECT cust_id, total_revenue,
	CASE 
    WHEN avg_revenue >=2500 THEN 'High'
    WHEN avg_revenue BETWEEN 1500 AND 2499 THEN 'Medium'
    WHEN avg_revenue < 1500 THEN 'Low'
    END AS revenue_tier
FROM avg_rev_per_cust
)
SELECT revenue_tier, COUNT(cust_id) AS customer_count, SUM(total_revenue) AS total_revenue
FROM rev_tier
GROUP BY revenue_tier;


-- 4. Region × Revenue tier view

WITH avg_rev_per_cust AS (
SELECT cust_id, AVG(revenue) AS avg_revenue, SUM(revenue) AS total_revenue
FROM revenue_d8
GROUP BY cust_id
),
rev_tier AS (
SELECT a.cust_id, c.region, a.total_revenue,
	CASE 
    WHEN a.avg_revenue >=2500 THEN 'High'
    WHEN a.avg_revenue BETWEEN 1500 AND 2499 THEN 'Medium'
    WHEN a.avg_revenue < 1500 THEN 'Low'
    END AS revenue_tier
FROM avg_rev_per_cust a 
JOIN customers_d8 c
ON a.cust_id = c.cust_id
)
SELECT region, revenue_tier, COUNT(cust_id) AS customer_count, SUM(total_revenue) AS total_revenue
FROM rev_tier
GROUP BY region, revenue_tier
ORDER BY region, revenue_tier;

-- 5. Identify focus segments

SELECT cust_id,
	CASE 
    WHEN AVG(revenue) >=2500 THEN 'Protect'
    WHEN AVG(revenue) BETWEEN 1500 AND 2499 THEN 'Grow'
    WHEN AVG(revenue) < 1500 THEN 'Ignore / Automate'
    END AS segment_action
FROM revenue_d8
GROUP BY cust_id;



-- Business Questions

-- 1. Which customers deserve white-glove support?
-- Customers 1 and 2 deserve white-glove support as they are High revenue tier customers.

-- 2. Which segment is risky to ignore but dangerous to over-invest in?
-- Medium tier is the danger zone, if ignored there is a chance of missing growth and if over-invest, there is a chance that ROI can be low.

-- 3. If budgets are cut, which segment would you protect first?
-- If budgets are cut, protect High segment first as the revenue is high because of these users and it helps maintain profit followed by mid level.

-- 4. What metric would you show a CEO in one slide from this analysis?
-- Revenue by segment and contribution by High tier users. The lesser the better.

