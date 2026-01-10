-- Day 19

-- 1. Monthly Revenue & Active Customers

SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(order_amount) AS total_return, COUNT(DISTINCT cust_id) AS active_customers
FROM orders_d19
GROUP BY month;

-- 2. Revenue per Customer per Month

SELECT cust_id, DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(order_amount) AS monthly_revenue
FROM orders_d19
GROUP BY cust_id, month;

-- 3. Customers with Increasing Revenue (MoM)

WITH month_rev AS (
SELECT cust_id, DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(order_amount) AS current_month_revenue
FROM orders_d19
GROUP BY cust_id, month
),
mom AS (
SELECT cust_id, month, current_month_revenue,
	LAG(current_month_revenue, 1, 0) OVER(PARTITION BY cust_id ORDER BY month) AS previous_month_revenue
FROM month_rev
)
SELECT cust_id, previous_month_revenue, current_month_revenue,
	CASE 
    WHEN current_month_revenue > previous_month_revenue AND previous_month_revenue != 0 THEN 'Increasing'
    WHEN current_month_revenue < previous_month_revenue AND previous_month_revenue != 0 THEN 'Decreasing'
    END AS trend
FROM mom;

-- 4. New vs Existing Customer Revenue (Monthly)

WITH init_order AS (
SELECT cust_id, MIN(order_date) AS initial_order_date
FROM orders_d19
GROUP BY cust_id
)
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
	SUM(CASE
		WHEN DATE_FORMAT(o.order_date, '%Y-%m') = DATE_FORMAT(i.initial_order_date, '%Y-%m') THEN o.order_amount
        END) AS new_customer_revenue,
	SUM(CASE
		WHEN DATE_FORMAT(o.order_date, '%Y-%m') > DATE_FORMAT(i.initial_order_date, '%Y-%m') THEN o.order_amount
        END) AS existing_customer_revenue
FROM orders_d19 o JOIN init_order i 
ON o.cust_id = i.cust_id
GROUP BY month
ORDER BY month;
        
-- 5. Customers with Spend Drop After First Purchase
WITH first_month AS (
SELECT cust_id, MIN(order_date) AS first_month
FROM orders_d19
GROUP BY cust_id
),
latest_month AS (
SELECT o.cust_id,
	SUM(CASE 
		WHEN DATE_FORMAT(o.order_date, '%Y-%m') = DATE_FORMAT(f.first_month, '%Y-%m') 
        THEN o.order_amount 
        END) AS first_purchase_revenue,
    SUM(CASE WHEN DATE_FORMAT(o.order_date, '%Y-%m') > DATE_FORMAT(f.first_month, '%Y-%m') 
		THEN o.order_amount 
        END) AS latest_revenue
FROM orders_d19 o JOIN first_month f
ON o.cust_id = f.cust_id
GROUP BY cust_id
)
SELECT cust_id, first_purchase_revenue, latest_revenue, 
	CASE 
    WHEN latest_revenue > first_purchase_revenue THEN 'Increased'
    WHEN latest_revenue < first_purchase_revenue THEN 'Dropped'
    END AS status
FROM latest_month;
	

-- Business Questions

-- 1. Why is revenue growth without customer growth risky?
/* It shows that there is too much dependency on a small customer base which increases churn risk in future. */ 

-- 2. Which is healthier: flat customers + rising revenue OR rising customers + flat revenue?
/* Rising customers + flat revenue can be considered healthier in early stage. In later stages, Flat customers + rising revenue will be beneficial. */

-- 3. How would RevOps use this data to decide where to invest?
/* The data can be used to identify the areas where customer spend is more and low, monthly expenditure, one-time customers and return customers, etc and make decisions
and plan to invest in MomM expansion, relevant products, improve operations, promotions, discounts/vouchers, etc. */

-- 4. What early signal shows future expansion potential?
-- Increasing revenue per active customer over consecutive months.
