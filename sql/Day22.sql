-- Day 22 - Pricing, Discounts & Profitability Analysis

-- 1. Net Revenue per Order

/* (Net Revenue = selling_price − discount_amount) */

SELECT order_id, selling_price - discount_amount AS net_revenue
FROM orders_d22;

-- 2. Total Discount Given per Customer

SELECT c.cust_id, c.cust_name, SUM(o.discount_amount) AS total_discount
FROM customers_d22 c LEFT JOIN orders_d22 o 
ON c.cust_id = o.cust_id
GROUP BY cust_id, cust_name;

-- 3. Contribution Margin per Order

/* (Margin = net_revenue − cost_price) */

WITH net_rev AS (
SELECT product_id, order_id, selling_price - discount_amount AS net_revenue
FROM orders_d22
)
SELECT n.order_id, n.net_revenue, p.cost_price, n.net_revenue - p.cost_price AS contribution_margin
FROM net_rev n JOIN products_d22 p
ON n.product_id = p.product_id
GROUP BY order_id
ORDER BY order_id;

-- 4. Average Margin % per Product

SELECT 
    p.product_name,
    ROUND(
        (SUM(o.selling_price - o.discount_amount) - SUM(p.cost_price)) 
        / SUM(o.selling_price - o.discount_amount) * 100,
        2
    ) AS avg_margin_percentage
FROM orders_d22 o
JOIN products_d22 p
ON o.product_id = p.product_id
GROUP BY p.product_name;

-- 5. Customers Who Look High Revenue but Low Margin

SELECT c.cust_id, c.cust_name, 
SUM(o.selling_price - o.discount_amount) AS total_net_revenue, 
SUM(o.selling_price - o.discount_amount) - SUM(p.cost_price) AS total_margin
FROM orders_d22 o 
JOIN customers_d22 c
ON o.cust_id = c.cust_id 
JOIN products_d22 p 
ON p.product_id = o.product_id
GROUP BY cust_id;

-- 6. Discount Dependency Analysis

WITH order_counts AS (
SELECT cust_id, COUNT(order_id) AS total_orders, 
SUM(CASE WHEN discount_amount > 0 THEN 1 ELSE 0 END) AS discounted_orders
FROM orders_d22
GROUP BY cust_id
)
SELECT cust_id, discounted_orders * 1.0 / total_orders AS discount_dependency_ratio
FROM order_counts
WHERE discounted_orders * 1.0 / total_orders > 0.5;

-- Business Questions

-- 1. Why can aggressive discounting be dangerous even if revenue grows?

-- Aggressive discounts will impact the short term revenue , attract low quality customers and impacts long term profits.

-- 2. Which product looks safest to scale based on margin?

-- The product with the highest and most stable margin after giving discounts is safe to scale even if its revenue is lower.

-- 3. If a customer has high revenue but low margin, what actions would you suggest?

-- Reduce discount eligibility, increase high margin plans and introduce minimum prices.

-- 4. How would RevOps use this data to redesign pricing or packaging?

-- Balance both acquisition percent and protect margin, plan discount rules and improve profits by targeting return customers.

-- 5. What signal here would worry a CFO the most?

-- Rising revenue with declining margin percentage.