-- Day 37

CREATE TABLE sales_d37 (
  order_id INT,
  customer_id INT,
  order_date DATE,
  revenue INT
);
INSERT INTO sales_d37 VALUES
(1, 1, '2023-01-01', 100),
(2, 1, '2023-02-01', 150),
(3, 1, '2023-03-01', 120),
(4, 2, '2023-01-01', 200),
(5, 2, '2023-02-01', 180),
(6, 3, '2023-02-01', 300);