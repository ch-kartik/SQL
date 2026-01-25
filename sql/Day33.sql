-- Day 33 - Churn Prediction Signals (Pre-Churn Analysis)

-- 1. Last order date per customer

SELECT cust_id, MAX(order_date) AS last_order
FROM orders_d33
GROUP BY cust_id;

-- 2. Days since last order (recency)

SELECT cust_id, DATEDIFF('2023-04-01', MAX(order_date)) AS days_since_last_order
FROM orders_d33
GROUP BY cust_id;

-- 3. Order frequency per customer

SELECT cust_id, COUNT(DISTINCT order_id) AS order_count
FROM orders_d33
GROUP BY cust_id;

-- 4. Average gap between orders per customer

SELECT cust_id, 
	ROUND(DATEDIFF(MAX(order_date), MIN(order_date)) / NULLIF(COUNT(order_id) - 1, 0), 0) AS avg_gap_days
FROM orders_d33
GROUP BY cust_id;

-- 5. Identify early churn risk customers

SELECT cust_id
FROM orders_d33
GROUP BY cust_id
HAVING COUNT(DISTINCT order_id) >= 2 AND DATEDIFF('2023-04-01', MAX(order_date)) > 30;

-- 6. Classify customers into churn signals

SELECT cust_id,
	CASE 
    WHEN DATEDIFF('2023-04-01', MAX(order_date)) <= 30 THEN 'Healthy'
    WHEN DATEDIFF('2023-04-01', MAX(order_date)) > 60 THEN 'High Risk'
    ELSE 'Warning'
    END AS status
FROM orders_d33
GROUP BY cust_id
ORDER BY cust_id;

-- Business Questions

-- 1. Why is increasing order gaps an early churn signal?
/* Increasing order gaps shows a break in the customer purchase behaviour and losing interest in the product before fully stopping the usage. */

-- 2. Which customer here looks dangerous to lose — not obvious churn, but risky?
-- Customer 3 is risky because they showed initial engagement but stopped early, this indicates failed activation rather than natural churn.

-- 3. Why is frequency decline more predictive than revenue decline?
/* Frequency decline acts as a leading indicator of customers losing interest in engaging with the product or service and the affect on loyalty whereas revenue
is a indicator that can be temporarily handled by price increases. */

-- 4. What action should RevOps take at “Warning” stage?
/* At warning stage, RevOps should trigger targeted outreach, review product usage data, and align CS + Product interventions before the customer crosses into high risk. */

-- 5. What metric from today would help forecast revenue risk?
-- Identify churn risk customers using churn signals