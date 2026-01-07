-- Day 16 

-- 1. Customer Engagement Summary

SELECT c.cust_id, c.signup_date, c.channel,  COUNT(o.order_id) AS total_orders, SUM(o.order_amount) AS total_revenue,
COUNT(DISTINCT DATE_FORMAT(o.order_date, '%Y-%m')) AS active_months
FROM customers_d16 c LEFT JOIN orders_d16 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id;

-- 2. Early Drop Risk

SELECT c.cust_id
FROM customers_d16 c JOIN orders_d16 o
ON c.cust_id = o.cust_id
GROUP BY cust_id
HAVING COUNT(o.order_id) = 1 AND COUNT(o.order_date) = 1;

-- 3. Revenue by Engagement Level

WITH class AS (
SELECT cust_id, 
	CASE
    WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) = 3 THEN 'Highly Engaged'
    WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) = 2 THEN 'Moderately Engaged'
    WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) = 1 THEN 'Low Engaged'
    END AS cust_classification
FROM orders_d16
GROUP BY cust_id
),
total_rev AS (
SELECT cust_id, order_amount FROM orders_d16
)
SELECT c.cust_classification, COUNT(DISTINCT c.cust_id) AS no_of_customers, SUM(tr.order_amount) AS total_revenue
FROM class c JOIN total_rev tr
ON c.cust_id = tr.cust_id
GROUP BY cust_classification;


-- 4. Channel Quality Check

WITH tv_tc AS (
SELECT c.`channel`, COUNT(DISTINCT c.cust_id) AS total_customers, SUM(o.order_amount) AS total_revenue
FROM customers_d16 c LEFT JOIN orders_d16 o
ON c.cust_id = o.cust_id
GROUP BY c.`channel`
)
SELECT `channel`, total_customers, total_revenue, ROUND(total_revenue / total_customers, 2) AS avg_revenue_per_customer
FROM tv_tc;

-- Business Questions

-- 1. Why is “active months” a better engagement signal than total orders?

/* Active months shows the repeatitive behaviour, willingness to spend regularly and loyalty of a customer indicating the return. Whereas total order doesnt mean
 that a customer is returning, there can be cases when a one-time customer may have placed multiple orders in a single day.

-- 2. If Ads bring more customers but lower engagement, should Ads be scaled?

-- Cautiously scale ads and try to convert the existing customers to increase their engagement by calculatively providing early bird offers/discounts/vouchers.

-- 3. Which customers would you target for retention campaigns first — and why?

-- First target should be highly engaged and high revenue customers because retention impact is highest there.

-- 4. What would you monitor monthly to catch churn early?

/* If a customer who signed up early is returning or not, this helps identify early churn. Also check if any customers are cancelling the subscription or orders. 
In case of feedback try to identify customer satisfaction score. */