-- Day 13

CREATE TABLE orders_d13 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    status VARCHAR(20)
);

INSERT INTO orders_d13 VALUES
(1, 101, '2025-01-05', 1200, 'completed'),
(2, 101, '2025-02-10', 1800, 'completed'),
(3, 101, '2025-03-15', 2500, 'completed'),
(4, 102, '2025-01-12', 900, 'completed'),
(5, 102, '2025-02-20', 1100, 'completed'),
(6, 103, '2025-02-05', 3000, 'completed'),
(7, 104, '2025-01-18', 700, 'completed'),
(8, 104, '2025-03-25', 800, 'completed'),
(9, 105, '2025-03-02', 4000, 'completed');