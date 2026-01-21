-- Day 29 - RFM-Style Customer Segmentation

-- 1. Last order date per customer

SELECT cust_id, MAX(order_date) AS last_order_date
FROM orders_d29
GROUP BY cust_id;

-- 2. Recency (days since last order)

SELECT cust_id, DATEDIFF('2023-03-31', MAX(order_date)) AS days_since_last_order
FROM orders_d29
GROUP BY cust_id;

-- 3. Frequency (number of orders per customer)

SELECT cust_id, COUNT(DISTINCT order_id) AS order_count
FROM orders_d29
GROUP BY cust_id;

-- 4. Monetary value (total revenue per customer)

SELECT cust_id, SUM(order_amount) AS total_revenue
FROM orders_d29
GROUP BY cust_id;

-- 5. Create a basic customer segment

SELECT cust_id,
	CASE 
    WHEN COUNT(DISTINCT order_id) = 1 THEN 'One-time'
    WHEN DATEDIFF('2023-03-31', MAX(order_date)) <= 30 AND COUNT(DISTINCT order_id) >= 2 THEN 'Champions'
    WHEN DATEDIFF('2023-03-31', MAX(order_date)) > 30 AND COUNT(DISTINCT order_id) >= 2 THEN 'At Risk'
    END AS segment
FROM orders_d29
GROUP BY cust_id;

-- Business Questions

-- 1. Why is recency often more important than total revenue?
-- Recency can be used to accurately predict future behaviour of customers and the current relevance of the business.

-- 2. Which customer would you try to retain first, and why?
-- In case there is a churn, iwould prefer toretain customer 1 considering the number of orders and the total revenue.

-- 3. Who should receive a discount vs who shouldn’t?
-- Customers 3 should receive discount to encourage loyalty and no discount for customers 2 and 4 as they are one time customers.

-- 4. How would RevOps use this segmentation differently than Marketing?
/* Marketing teams focus is on acquisition and reactivation campaigns where as RevOps teams focuses on prioritiation, resource allocation and forecast risk. */
