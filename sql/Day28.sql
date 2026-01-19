-- Day 28 - Cohort Retention %

-- 1. Assign each customer to a signup cohort (YYYY-MM)

SELECT cust_id, DATE_FORMAT(signup_date, '%Y-%m') AS signup_cohort
FROM customers_d28
GROUP BY cust_id;

-- 2. Count total customers per cohort

WITH cohort AS (
SELECT cust_id, DATE_FORMAT(signup_date, '%Y-%m') AS signup_cohort
FROM customers_d28
GROUP BY cust_id
)
SELECT signup_cohort,  COUNT(cust_id) AS total_customers
FROM cohort
GROUP BY signup_cohort;

-- 3. For each cohort, count active customers per month

WITH signup AS (
SELECT cust_id, DATE_FORMAT(signup_date,'%Y-%m') AS signup_cohort 
FROM customers_d28
GROUP BY cust_id
)
SELECT s.signup_cohort, DATE_FORMAT(o.order_date, '%Y-%m') AS order_month, COUNT(DISTINCT o.cust_id) AS active_customers
FROM signup s JOIN orders_d28 o
ON s.cust_id = o.cust_id
GROUP BY s.signup_cohort, order_month; 

-- 4. Calculate retention % per cohort per month

WITH cohort AS (
SELECT cust_id, DATE_FORMAT(signup_date, '%Y-%m') AS signup_cohort
FROM customers_d28
),
cohort_size AS (
SELECT signup_cohort, COUNT(*) AS cohort_size
FROM cohort
GROUP BY signup_cohort
),
orders AS (
SELECT DISTINCT cust_id, DATE_FORMAT(order_date, '%Y-%m') AS order_month
FROM orders_d28
)
SELECT c.signup_cohort, o.order_month, ROUND(COUNT(DISTINCT o.cust_id) * 100.0 / cs.cohort_size, 2) AS retention_percentage
FROM cohort c JOIN orders o
ON c.cust_id = o.cust_id
JOIN cohort_size cs
ON c.signup_cohort = cs.signup_cohort
GROUP BY c.signup_cohort, o.order_month, cs.cohort_size
ORDER BY c.signup_cohort, o.order_month;

-- 5. Identify which cohort retains best after Month 1
/* The January 2023 cohort appears healthiest after Month 1 because it retains the highest proportion of customers across subsequent months */

-- Business Questions

-- 1. Why is Month-1 retention more important than Month-0?
-- Month 0 is about user onboarding while Month 1 is about user's activation and engagement leading to customer retention.

-- 2. What does it mean if retention drops sharply after Month-1?
-- It means users who were active during initial period have not returned the next month. This indicates an issue with ser experience and product strategyafter onboarding.

-- 3. If a newer cohort retains worse than older ones, what are 2 likely causes?
-- Change in acquiring and adding customers and change in the market conditions.

-- 4. Which team (Product / Marketing / RevOps) owns improving retention — and why?
-- Mainly with product and marketing teams closely working with Customer Success team while leveraging support from RevOps.

-- 5. What metric would you show leadership alongside cohort retention?
/* Show leadership the metrics that connects behaviour of customer to the financial health and future growth of business like customer 
lifetime value, customer acquisition cost, net revenue, margin, etc. */