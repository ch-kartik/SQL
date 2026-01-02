-- Day 12

CREATE TABLE orders_d12 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    status VARCHAR(20)
);

INSERT INTO orders_d12 VALUES
(301, 1, '2025-01-05', 3000, 'completed'),
(302, 1, '2025-02-10', 4000, 'completed'),
(303, 2, '2025-02-15', 1500, 'completed'),
(304, 3, '2025-01-20', 5000, 'completed'),
(305, 3, '2025-03-01', 3000, 'completed'),
(306, 4, '2025-03-05', 800, 'completed'),
(307, 5, '2025-03-10', 2500, 'completed');