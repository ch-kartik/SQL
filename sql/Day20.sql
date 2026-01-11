-- Day 20 - Customer Segmentation & Value Analysis

-- 1. Total Revenue per Customer

SELECT c.cust_id, c.cust_name, SUM(o.order_amount) AS total_revenue
FROM customers_d20 c LEFT JOIN orders_d20 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id, c.cust_name;

-- 2. Number of Orders per Customer

SELECT c.cust_id, c.cust_name, COUNT(o.order_id) AS total_orders
FROM customers_d20 c JOIN orders_d20 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id, c.cust_name; 

-- 3. Average Order Value (AOV) per Customer

WITH revenue_count AS (
SELECT c.cust_id, c.cust_name, SUM(o.order_amount) AS total_revenue, COUNT(order_id) AS order_count
FROM customers_d20 c JOIN orders_d20 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id
)
SELECT cust_id, cust_name, ROUND(total_revenue / order_count, 2) AS avg_order_value
FROM revenue_count;

-- 4. Segment Customers by Value

SELECT c.cust_id, c.cust_name, SUM(o.order_amount) AS total_revenue, 
	CASE
    WHEN SUM(o.order_amount) >= 700 THEN 'High Value'
    WHEN SUM(o.order_amount) BETWEEN 300 AND 699 THEN 'Medium Value'
    ELSE 'Low Value'
    END AS customer_segment
FROM customers_d20 c JOIN orders_d20 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id;

-- 5. Revenue Contribution Percentage

WITH revenue AS (
SELECT c.cust_id, c.cust_name, SUM(o.order_amount) AS cust_total_revenue,
	(SELECT SUM(order_amount) FROM orders_d20) AS overall_revenue
FROM customers_d20 c JOIN orders_d20 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id
)
SELECT cust_id, cust_name, cust_total_revenue AS total_revenue, ROUND(cust_total_revenue / overall_revenue * 100, 2) AS revenue_percentage
FROM revenue;


-- Business Questions

-- 1. Which customer segment should the company focus retention efforts on and why?
/* Retention efforts should be focused on High Value customer segment. In case of churn, losing low value customers doesnt impact the revene as much as losing 
high value customers. At the same time try to increase spend of low value customers to turn them into high value customers. */

-- 2. Is having many low-value customers always bad for a business?
/* Sometimes it could be beneficial in terms of market penetration, stable revenue source, etc. But for healthy growth of business, in long term focus to transition the low value
customers into high value customers. */ 

-- 3. Which country seems to have higher value customers in this dataset?
-- Based on this limited dataset, USA & Germany have high value customers.

-- 4. If marketing budget is limited, which 2 customers would you target first?
-- Emily and Sophia as they are already spending more so hogh chances to upsell, educate lower value customers later.

-- 5. What extra data would you ask for to improve segmentation quality?
-- Recent last purchase details, customer tenure(new or return), product details, discounts used, etc.