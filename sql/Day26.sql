-- Day 26 - Customer Recency, Frequency & Revenue

-- 1. Last order date per customer

SELECT cust_id, MAX(order_date) AS last_order_date
FROM orders_d26
GROUP BY cust_id;

-- 2. Days since last order per customer

SELECT cust_id, DATEDIFF(CURDATE(), MAX(order_date)) AS days_since_last_order
FROM orders_d26
GROUP BY cust_id;

-- 3. Number of orders per customer

SELECT cust_id, COUNT(DISTINCT order_id) AS order_count
FROM orders_d26
GROUP BY cust_id;

-- 4. Total revenue per customer 

SELECT cust_id, SUM(order_amount) AS total_revenue
FROM orders_d26
GROUP BY cust_id;

-- 5. Classify customers based on recency

SELECT cust_id, 
	CASE
    WHEN MAX(order_date) >= '2023-02-28' - INTERVAL 30 DAY THEN 'Active'
    WHEN MAX(order_date) >= '2023-02-28' - INTERVAL 60 DAY THEN 'At Risk'
    ELSE 'Inactive'
    END AS status
FROM orders_d26
GROUP BY cust_id;

-- 6 . Customers who placed only one order ever

SELECT cust_id
FROM orders_d26
GROUP BY cust_id
HAVING COUNT(DISTINCT order_id) = 1;

-- Business Questions

-- 1. Why is recency often a stronger churn signal than revenue?
/* Recency shows whether a customer is still engaged, while revenue is historical. Retention teams act on current behavior and not on past spending. */

-- 2. Which customer would you prioritize for a retention campaign, and why?
/* Customer 4 should be prioritized for a retention campaign as last order is in Feb month and user didn't order in March compared to Customer 2 who 
didn't order since last two months.  */

-- 3. Who looks valuable long-term but slightly risky?
-- Customer 1 looks valuable but slightly risky as highest revenue contribution would get affected in case of churn. Appropriate measures should be taken to retai this customer.

-- 4. If you could send only one discount, who should get it?
-- Customer 4 considering there is a chance to make this customer to return.

-- 5. How would RevOps use this data differently than Marketing?
/* Marketing teams focus is on acquisition and reactivation campaigns where as RevOps teams focuses on prioritiation, resource allocation and forecst risk. */
