-- Day 27 - Cohort & Retention Basics

-- 1. Assign each customer to a signup cohort (YYYY-MM)

SELECT cust_id, DATE_FORMAT(signup_date, '%Y-%m') AS signup_cohort
FROM customers_d27
GROUP BY cust_id;

-- 2. Count customers per cohort

WITH cohort AS (
SELECT cust_id, MIN(DATE_FORMAT(signup_date, '%Y-%m')) AS signup_cohort
FROM customers_d27
GROUP BY cust_id
)
SELECT signup_cohort, COUNT(DISTINCT cust_id) AS customer_count
FROM cohort
GROUP BY signup_cohort;

-- 3. For each cohort, find how many customers placed at least one order after signup month

WITH cohort AS (
SELECT cust_id, MIN(DATE_FORMAT(signup_date, '%Y-%m')) AS signup_cohort, signup_date
FROM customers_d27
GROUP BY cust_id
)
SELECT c.signup_cohort, COUNT(DISTINCT c.cust_id) AS cust_count 
FROM cohort c JOIN orders_d27 o
ON c.cust_id = o.cust_id
WHERE DATE_FORMAT(o.order_date, '%Y-%m') > c.signup_cohort
GROUP BY c.signup_cohort;

-- 4. Retained customers per cohort

WITH cohort AS (
SELECT cust_id, MIN(DATE_FORMAT(order_date, '%Y-%m')) AS first_order_cohort
FROM orders_d27
GROUP BY cust_id
),
orders_with_cohort AS (
SELECT o.cust_id, DATE_FORMAT(o.order_date, '%Y-%m') AS order_month, c.first_order_cohort
FROM cohort c JOIN orders_d27 o
ON c.cust_id = o.cust_id
)
SELECT first_order_cohort, COUNT(DISTINCT cust_id) AS retained_customers
FROM orders_with_cohort 
WHERE order_month > first_order_cohort
GROUP BY first_order_cohort
ORDER BY first_order_cohort;


-- 5. Revenue generated per cohort

WITH cohort AS (
SELECT cust_id, MIN(DATE_FORMAT(order_date, '%Y-%m')) AS first_order_cohort
FROM orders_d27
GROUP BY cust_id
)
SELECT c.first_order_cohort, SUM(o.order_amount) AS total_revenue
FROM cohort c JOIN orders_d27 o
ON c.cust_id = o.cust_id
GROUP BY c.first_order_cohort
ORDER BY c.first_order_cohort;


-- Business Questions

-- 1. Why is cohort-based retention more useful than overall retention?
/* Overall retention hides time effect. Cohort retention shows whether new customers behave better or worse than earlier ones, which helps identify onboarding,
 pricing, or product changes.*/

-- 2. Which cohort looks healthiest based on this data?
-- The healthiest cohort is the one with highest month-over-month retention and sustained revenue, not just total revenue.

-- 3. If newer cohorts retain worse than older ones, what could that signal?
-- It shows the underlying issue related to custommer onboarding, changes in the audience and market, decline in product usage, lack of customer support.

-- 4. How would RevOps act if February cohort retention drops sharply?
/* Initiate cross functional analysis to identify root cause of the drop, review and develop the actions to be taken targetting marketing, sales and cstomer success.
Also focus on implementing continuous optimization while updating performance metrics if required. */

-- 5. Why do SaaS companies obsess over cohort charts?
/* Because it provides the detailed, time based insights into customer behaviour which are invisible in aggregate metrics. This level of detail is crucial for healthy
business growth. */