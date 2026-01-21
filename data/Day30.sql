-- Day 30

CREATE TABLE customers_d30 (
    cust_id INT PRIMARY KEY,
    signup_date DATE
);

INSERT INTO customers_d30 VALUES
(1, '2023-01-01'),
(2, '2023-01-10'),
(3, '2023-02-01'),
(4, '2023-02-15');

CREATE TABLE orders_d30 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d30(cust_id)
);

INSERT INTO orders_d30 VALUES
(101, 1, '2023-01-05', 500),
(102, 1, '2023-02-10', 700),
(103, 1, '2023-03-15', 600),
(104, 2, '2023-01-20', 400),
(105, 3, '2023-02-05', 300),
(106, 3, '2023-03-05', 300),
(107, 4, '2023-02-20', 1000);