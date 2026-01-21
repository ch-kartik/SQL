-- Day 30 - Customer Lifetime & Revenue Stability

-- 1. Customer Lifetime (in days)

SELECT c.cust_id, MIN(o.order_date) AS first_order, MAX(o.order_date) AS last_order, DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS lifetime_days
FROM orders_d30 o JOIN customers_d30 c
ON c.cust_id = o.cust_id
GROUP BY c.cust_id;

-- 2. Total Revenue & Order Count per Customer

SELECT cust_id, SUM(order_amount) AS total_revenue, COUNT(DISTINCT order_id) AS order_count
FROM orders_d30 
GROUP BY cust_id;

-- 3. Average Revenue per Order per Customer
WITH rev_order AS (
SELECT cust_id, SUM(order_amount) AS total_revenue, COUNT(DISTINCT order_id) AS order_count
FROM orders_d30 
GROUP BY cust_id
)
SELECT cust_id, ROUND(total_revenue / order_count, 2) AS avg_order_value
FROM rev_order
GROUP BY cust_id
ORDER BY cust_id;

-- 4. Revenue Stability Indicator

SELECT c.cust_id, 
	CASE
    WHEN COUNT(DISTINCT o.order_id) > 1 AND DATEDIFF(MAX(o.order_date), MIN(o.order_date)) >= 30 THEN 'Stable'
    ELSE 'Unstable'
    END AS stability_flag
FROM customers_d30 c JOIN orders_d30 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id
ORDER BY c.cust_id;

-- 5. High Value but Risky Customers

SELECT c.cust_id, SUM(o.order_amount) AS total_revenue, DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS lifetime_days
FROM customers_d30 c JOIN orders_d30 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id
HAVING total_revenue >= 1000 AND lifetime_days < 45
ORDER BY c.cust_id;

-- Business Questions

-- 1. Why is customer lifetime more important than single large orders?
/* Cusomer lifetime indicates the metrics of loyalty and the impact on revenue growth in long run whereas single large orders may generate revenue in short term but not much
beneficial for business health in long run. */ 

-- 2. Which customer here looks most dangerous to lose, and why?
-- Customer 1 is dangerous to lose consdering the total revenue and order count which are both higher than other customers.

-- 3. Why is revenue stability important for forecasting?
-- Revenue stability isimportant as it it makes predictions reliable and accurate. This helps improve business planning and risk management.

-- 4. If you had to choose between Customer 1 and Customer 4 for retention spend, who and why?
/* Customer 1 will protect the existing revenue while Customer 4 is an expansion bet but not yet proven. */

-- 5. What metric from today would you show a CFO?
-- Customer lifetime and Revenue stability