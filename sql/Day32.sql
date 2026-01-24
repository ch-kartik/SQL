-- Day 32 - Rolling Activity & Early Churn Signals

-- 1. Last order date per customer

SELECT cust_id, MAX(order_date) AS last_order_date
FROM orders_d32
GROUP BY cust_id;

-- 2. Days since last order (recency)

SELECT cust_id, MAX(order_date) AS last_order_date, DATEDIFF('2023-03-31', MAX(order_date)) AS days_since_last_order
FROM orders_d32
GROUP BY cust_id;

-- 3.  Orders placed in the last 30 days per customer

SELECT cust_id, COUNT(DISTINCT order_id) AS orders_placed
FROM orders_d32
WHERE order_date >= '2023-03-31' - INTERVAL 30 DAY
GROUP BY cust_id
ORDER BY cust_id;

-- 4. Flag customers as “Recently Active” or “Fading”

WITH recent_order AS (
SELECT DISTINCT cust_id
FROM orders_d32
WHERE order_date >= '2023-03-31' - INTERVAL 30 DAY
)
SELECT c.cust_id, 
	CASE
    WHEN ro.cust_id IS NOT NULL THEN 'Recently Active'
    ELSE 'Fading'
    END AS cust_status
FROM customers_d32 c LEFT JOIN recent_order ro
ON c.cust_id = ro.cust_id;

-- 5. Identify early churn risk customers

SELECT cust_id
FROM orders_d32
GROUP BY cust_id
HAVING COUNT(DISTINCT order_id) >= 2 AND DATEDIFF('2023-03-31', MAX(order_date)) > 30;


-- Business Questions

-- 1. Why is a rolling 30-day window better than calendar months for churn detection?
-- Rolling window provides consistent, real time measure of ser behaviour which is accurate and avoids volatility.

-- 2. Which customer here would worry you most and why?
/* Customer 3 as they show early repeat behaviour but stopped ordering later. This indicate potential experience or value breakdown rather than low intent. */

-- 3. Why are “fading” customers more important than already churned ones?
/* Because fading customers shows preventable loss than the churned customers who are permanent loss. There is still a chance to recover the ading customers as they are
not completely inactive yet. */

-- 4. How could RevOps act before revenue is lost?
-- By providing pro active monitoring, outreaching after 21 inactive days, priortize high LTV fading customers and coordinste with cutomer success and marketing teams.

-- 5. What KPI would you build from today’s analysis?
-- Percentage of High-Value Customers Inactive >30 Days