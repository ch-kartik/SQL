-- Day 12 

-- 1. First Purchase Month per Customer

SELECT cust_id, MIN(DATE_FORMAT(order_date, '%Y-%m')) AS purchase_month
FROM orders_d12
GROUP BY cust_id;

-- 2. New vs Returning Customers per Month

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS `month`, 
COUNT(DISTINCT CASE 
    WHEN DATE_FORMAT(o.order_date, '%Y-%m') = DATE_FORMAT(f.first_order_date, '%Y-%m') THEN o.cust_id
    END) AS new_cust_count,
COUNT(DISTINCT CASE 
    WHEN DATE_FORMAT(o.order_date, '%Y-%m') > DATE_FORMAT(f.first_order_date, '%Y-%m') THEN o.cust_id
    END) AS return_cust_count
FROM orders_d12 o JOIN (SELECT cust_id, MIN(order_date) AS first_order_date FROM orders_d12 GROUP BY cust_id) f 
ON o.cust_id  = f.cust_id
GROUP BY `month`;

-- 3. Revenue Split: New vs Returning

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS `month`,
	SUM(CASE 
		WHEN DATE_FORMAT(o.order_date, '%Y-%m') = DATE_FORMAT(f.first_order_date, '%Y-%m') THEN o.order_amount 
        END) AS revenue_new_cutomers,
	SUM(CASE
		WHEN DATE_FORMAT(o.order_date, '%Y-%m') > DATE_FORMAT(f.first_order_date, '%Y-%m') THEN o.order_amount
        END) AS revenue_return_customers
FROM orders_d12 o JOIN (SELECT cust_id, MIN(order_date) AS first_order_date FROM orders_d12 GROUP BY cust_id) f
ON o.cust_id = f.cust_id
WHERE status = 'completed'
GROUP BY `month`;

-- 4. Retention Signal

SELECT DISTINCT cust_id
FROM orders_d12
WHERE DATE_FORMAT(order_date, '%Y-%m') = '2025-01'
AND cust_id IN (
	SELECT cust_id 
    FROM orders_d12
    WHERE DATE_FORMAT(order_date, '%Y-%m') IN ('2025-02', '2025-03')
);

-- Business Questions

-- 1. If most revenue comes from new customers, is that good or bad? Why?

/* In the initial stage of business, its good to have revenue from new customers as it helps recover CAQ but in long term it is risky as qcquisition is expensive and 
it will affect revenue if there is no retention. */

-- 2. What does high returning-customer revenue indicate about the product?

-- It indicates customer satisfaction, shows the quality of the product and the power of pricing product so it reaches to the right customer.

-- 3. If returning customer count is low but revenue is high, what could that mean?

/* The revenue is dependent on a small group of loyal customers which is good in short termm but is risky for long term incase there is churn. */

