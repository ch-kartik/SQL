-- Day 13

-- 1. Customer Order Summary

SELECT DISTINCT cust_id, COUNT(order_id) AS total_orders, SUM(order_amount) AS total_revenue, ROUND(AVG(order_amount), 2) AS avg_order_value
FROM orders_d13
GROUP BY cust_id; 

-- 2. Revenue Contribution by Customer

WITH rev AS (
SELECT cust_id, SUM(order_amount) AS total_revenue_per_cust, (SELECT SUM(order_amount) FROM orders_d13) AS overall_revenue
FROM orders_d13
GROUP BY cust_id
)
SELECT cust_id, ROUND((total_revenue_per_cust / overall_revenue) * 100, 2) AS percent_contribute_to_overall_revenue
FROM rev;

-- 3. Value-Based Customer Segmentation

SELECT cust_id, 
	CASE
	WHEN AVG(order_amount) >= 2500 THEN 'High Value'
    WHEN AVG(order_amount) BETWEEN 1500 AND 2499 THEN 'Medium Value'
    ELSE 'Low Value'
    END AS cust_class
FROM orders_d13
GROUP BY cust_id;
        
-- 4. Revenue Efficiency by Month

SELECT DATE_FORMAT(order_date, '%Y-%m') AS `month`, 
SUM(order_amount) AS total_revenue, 
COUNT(order_id) AS total_orders,
ROUND(AVG(order_amount), 2) AS avg_order_value
FROM orders_d13
GROUP BY `month`;

-- 1. Why is average order value often a better metric than total orders?

/* Average order value shows quality of revenue and not just volume. It helps understand customer spending behavior and profit, whereas total orders 
only shows activity  */

-- 2. If revenue grows but AOV stays flat, what does that tell you?

-- Revenue growth comes from more orders or more customers, not from higher spend per order. This might increase operational costs without improving unit economics.

-- 3. Would you rather grow revenue by: increasing order count (or) increasing AOV ? Why?

/* Both of these are to be used for a good business, Increasing AOV is usually more efficient short-term, while increasing order count supports long-term growth. 
The right choice depends on acquisition cost and margins. */