-- Day - 9

-- 1. Customer Spend Segmentation

WITH total_amount AS (
SELECT cust_id, SUM(order_amount) AS total_spend
FROM orders_d9
WHERE `status` = 'completed'
GROUP BY cust_id
),
segment_details AS (
SELECT cust_id, total_spend,
	CASE
    WHEN total_spend >= 10000 THEN 'High Value'
    WHEN total_spend BETWEEN 5000 AND 9999 THEN 'Medium Value'
    WHEN total_spend < 5000 THEN 'Low Value'
    END AS segment
FROM total_amount
)
SELECT cust_id, total_spend, segment
FROM segment_details;

-- 2. Order Status Metrics

SELECT COUNT(DISTINCT order_id) AS total_orders, 
	COUNT(CASE WHEN `status` = 'completed' THEN order_id END) AS completed_orders,
    COUNT(CASE WHEN `status` = 'cancelled' THEN order_id END) AS cancelled_orders
FROM orders_d9;

-- 3. Buyer vs Non-Buyer Flag

SELECT c.cust_id, c.cust_name,
	CASE
    WHEN SUM(CASE WHEN `status` = 'completed' THEN 1 ELSE NULL END) >= 1 THEN 'Buyer'
    ELSE 'Non Buyer'
    END AS cust_status
FROM customers_d9 c LEFT JOIN orders_d9 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id;

--  Business Questions

-- 1. Why is it risky to define “High Value Customer” using only order count instead of revenue?
/* Order count does not determine if a user is high value as we need to consider other factors such as the type of order placed by user and the value of the order. 
There may be cases where a user might have placed a single order but it might be of greater value in terms of price compared to a user who placd two or more orders but
of lesser amount. */

-- 2. If there are many Non Buyers, what 2 actions could sales or marketing take?
/* If there are many non-buyers, first the reason for this occrrence should be understood and then marketing team should come up with a plan to target the right 
audience to improve the business and reach out to a larger audience. The sales team should focus on pitching the products of various ranges and types. If possible
offer discounts or vouchers to pull customers and maintain the customer loyalty in long run. */

-- 3. Why would leadership prefer segmented metrics instead of one overall revenue number?
/* Leadership prefers segmented metrics as it would be easier to understabd the complete details of the customers, sales, products being sold and the ones not preferred, 
region wise insights, etc. */