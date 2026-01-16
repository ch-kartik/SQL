-- Day 24 - Customer Value & Behavior Analysis

-- 1. Total revenue per customer

SELECT c.cust_id, c.cust_name, SUM(o.order_amount) AS total_revenue
FROM customers_d24 c JOIN orders_d24 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id, c.cust_name;

-- 2. First order date and last order date per customer

SELECT cust_id, MIN(order_date) AS first_order_date, MAX(order_date) AS last_order_date
FROM orders_d24
GROUP BY cust_id;

-- 3. Customers with more than 1 order (repeat customers)

SELECT cust_id, COUNT(order_id) AS number_of_orders
FROM orders_d24
GROUP BY cust_id
HAVING number_of_orders > 1;

-- 4. Monthly revenue trend

SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(order_amount) AS total_revenue
FROM orders_d24
GROUP BY month
ORDER BY month;

-- 5. Average order value per customer

SELECT cust_id, ROUND(AVG(order_amount)) AS avg_order_value
FROM orders_d24
GROUP BY cust_id;

-- 6. Customers inactive after February 2023

SELECT cust_id
FROM orders_d24
GROUP BY cust_id
HAVING MAX(order_date) <= '2023-02-28';


-- Business Questions

-- 1. Why are repeat customers more valuable than one-time customers?
/* Repeat customers lower acquisition cost, improve predictability of revenue, and increase lifetime value. Businesses with strong repeat behavior grow more 
sustainably than those relying only on new customers. */

-- 2. Which customer here looks most valuable long-term, and why?
/* Customers 1 and 4 look most valuable because they show repeat behavior across months, indicating retention potential rather than one-time purchases. */

-- 3. If revenue is growing but repeat customers are flat, what risk does the business face?
/* In short term the revenue growth may look good but in long term this will have an impact on the business in case there is a churn. It shows that there is a need to
increase the customer base, improve customer loyalty and customer lifetime value. This creates fragile growth because acquisition costs increase while customer 
lifetime value stays low. */
	
-- 4. How would RevOps use this data to improve retention?
/* Segment customers by behavior, identify drop-off points, trigger retention campaigns for inactive users, and align marketing spend toward channels bringing repeat customers */