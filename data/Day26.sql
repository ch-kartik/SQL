-- Day 26

CREATE TABLE customers_d26 (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    signup_date DATE
);

INSERT INTO customers_d26 VALUES
(1, 'Alice', '2023-01-01'),
(2, 'Bob', '2023-01-05'),
(3, 'Charlie', '2023-02-01'),
(4, 'Diana', '2023-02-10');

CREATE TABLE orders_d26 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d26(cust_id)
);

INSERT INTO orders_d26 VALUES
(101, 1, '2023-01-10', 200),
(102, 1, '2023-02-10', 300),
(103, 1, '2023-03-10', 400),
(104, 2, '2023-01-15', 150),
(105, 3, '2023-02-15', 250),
(106, 3, '2023-03-20', 300),
(107, 4, '2023-02-20', 500);