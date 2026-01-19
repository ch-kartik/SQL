-- Day 28

CREATE TABLE customers_d28 (
    cust_id INT PRIMARY KEY,
    signup_date DATE
);

INSERT INTO customers_d28 VALUES
(1, '2023-01-05'),
(2, '2023-01-15'),
(3, '2023-02-02'),
(4, '2023-02-20'),
(5, '2023-03-10');

CREATE TABLE orders_d28 (
    order_id INT,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d28(cust_id)
);

INSERT INTO orders_d28 VALUES
(101, 1, '2023-01-10', 100),
(102, 1, '2023-02-12', 120),
(103, 1, '2023-03-15', 130),
(104, 2, '2023-01-20', 90),
(105, 3, '2023-02-10', 110),
(106, 3, '2023-03-05', 115),
(107, 4, '2023-02-25', 80),
(108, 5, '2023-03-20', 140);